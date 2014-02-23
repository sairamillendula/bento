class Admin::OrdersController < Admin::BaseController
  before_action :set_order, only: [:update, :mark_as_shipped, :cancel]
  set_tab :orders
  helper_method :sort_column, :sort_direction

  def index
    @orders = Order.includes(:client).order(sort_column + " " + sort_direction).page(params[:page]).per(20)
    @orders = @orders.where(id: params[:order_ids]) if params[:order_ids].present?

    respond_to do |format|
      format.html
      format.pdf do
        pdf = OrdersPdf.new(@orders)
        send_data pdf.render, filename: "#{t 'order'}.pdf", type: "application/pdf", disposition: "inline"
      end
    end
  end

  def show
    @order = Order.includes(:client, :audits, :shipping_address, :billing_address).find(params[:id])

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
        format.html { redirect_to admin_order_url(@order), notice: 'Order was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def mark_as_shipped
    @order.ship(current_user)

    respond_to do |format|
      if @order.errors.blank?
        format.html { redirect_to admin_order_url(@order), notice: 'Order shipped.' }
        format.js
      else
        format.html { render action: "index", notice: 'An error occured. Please try again.' }
        format.js
      end
    end
  end

  def cancel
    @order.cancel(current_user)

    respond_to do |format|
      if @order.errors.blank?
        format.html { redirect_to admin_order_url(@order), notice: 'Order cancelled.' }
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

  def abandoned
    @carts = Cart.with_items.includes(:items).page(params[:page]).per(20)
  end

  private

    def safe_params
      params.require(:order).permit(:state, :shipped_at, 
                                    shipping_address_attributes: [:id, :address1, :address2, :city, :country, :postal_code, :province],
                                    billing_address_attributes: [:id, :address1, :address2, :city, :country, :postal_code, :province] )
    end

    def set_order
      @order = Order.find(params[:id])
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end

    def sort_column
      Order.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
    end

end