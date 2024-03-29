class Reseller::OrdersController < Reseller::BaseController
  before_action :set_order, only: [:update]
  set_tab :orders
  helper_method :sort_column, :sort_direction, :shipping

  def index
    @orders = @current_user.orders.reseller.includes(:client).order(sort_column + " " + sort_direction).page(params[:page]).per(20)    # @orders = @orders.where(id: params[:order_ids]) if params[:order_ids].present?

    respond_to do |format|
      format.html
      format.pdf do
        pdf = OrdersPdf.new(@orders)
        send_data pdf.render, filename: "#{t 'order'}.pdf", type: "application/pdf", disposition: "inline"
      end
    end
  end

  def new
    @cart = @current_user.carts.find(session[:reseller_cart_id])
    @order = Order.new
    @order.build_billing_address.copy(@cart.billing_address)
    @order.build_shipping_address.copy(@cart.shipping_address)
    shipping
  end

  def show
    @order = @current_user.orders.includes(:client, :audits, :shipping_address, :billing_address).find(params[:id])

    respond_to do |format|
      format.html
      format.pdf do
        pdf = OrdersPdf.new([@order])
        send_data pdf.render, filename: "#{t 'order'} ##{@order.code}.pdf", type: "application/pdf", disposition: "inline"
      end
    end
  end

  def edit
    @order = Order.includes(:shipping_address, :billing_address).find(params[:id])
  end

  def update
    respond_to do |format|
      if @order.update_attributes(safe_params)
        format.html { redirect_to reseller_order_url(@order), notice: 'Order was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def create

    @order = @current_user.orders.new(safe_params)
    @cart = @current_user.carts.find(session[:reseller_cart_id])

    # Reseller order has no shipping price
    @order.shipping_price = 0
    @order.tax_rate = 0
    @order.total = @cart.total
    @order.reseller_order = true

    unless @order.valid?
      shipping
      render action: 'new' and return
    end
    respond_to do |format|
      if @order.save_with_payment(@cart)
        @cart.items.each do |item|
          item.cart_id = nil
          @order.items << item
        end
        StoreMailer.order_receipt(@order).deliver
        AdminMailer.new_order(@order).deliver
        @current_user.carts.find(session[:reseller_cart_id]).destroy
        session[:reseller_cart_id] = nil

        begin
        WebhookWorker.perform_async(@order.id)
        rescue => e
          logger.error "Sidekiq error while perform_async order: #{@order.code}, #{e.message}"
          flash[:error] = "An error occured."
          format.html { redirect_to reseller_order_url(@order), notice: 'Order was successfully created.' }
        end

        format.html { redirect_to reseller_order_url(@order), notice: 'Order was successfully created.' }
      else
        shipping
        format.html { render action: 'new' }
      end
    end
  end

  def cancel
    @order.cancel(current_user)

    respond_to do |format|
      if @order.errors.blank?
        format.html { redirect_to reseller_order_url(@order), notice: 'Order cancelled.' }
        format.js
      else
        format.html { render action: "index", notice: 'An error occured. Please try again.' }
        format.js
      end
    end
  end

  def print
    # find by id: params[:order_ids]
    # send to pdf
  end


  private

    def safe_params
      params.require(:order).permit(:state, :shipped_at, :shipping_rate, :stripe_card_token,
                                    shipping_address_attributes: [:id, :address1, :address2, :city, :country, :postal_code, :province, :full_name],
                                    billing_address_attributes: [:id, :address1, :address2, :city, :country, :postal_code, :province, :full_name]
      )
    end

    def set_order
      @order = @current_user.orders.find(params[:id])
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end

    def sort_column
      Order.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
    end
    
    def shipping
      @shipping_country = ShippingCountry.find_by_country(@current_user.reseller_request.country) || ShippingCountry.find_by_country('WORLDWIDE')
      shipping_rates = (@shipping_country && @shipping_country.rates.order('price ASC')) || []
      @applicable_rates = shipping_rates.select {|shipping_rate| shipping_rate.criteria == 'price-based' }
      @shipping_estimate = ShippingRate.estimate(@cart.subtotal.to_f.round(2), @applicable_rates)
    end
  end