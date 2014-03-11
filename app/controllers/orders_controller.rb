class OrdersController < ApplicationController
  before_filter :require_login, only: [:index, :show]

  def index
  	@orders = current_user.orders.order('created_at DESC')
  end

	def new
		@cart = current_cart
    @currency = cookies[:currency]

    if @cart.items.empty?
      redirect_to products_url, notice: "#{t 'cart.is_empty', default: 'Cart is empty'}."
      return
    end

    @shipping_country = ShippingCountry.find_by_country(@cart.shipping_address.country) || ShippingCountry.find_by_country('WORLDWIDE')
    shipping_rates = (@shipping_country && @shipping_country.rates.order('price ASC')) || []

    # TODO: add weight check
    @applicable_rates = shipping_rates.select {|shipping_rate| shipping_rate.criteria == 'price-based' && @cart.subtotal >= shipping_rate.min_criteria }

    @shipping_estimate = ShippingRate.estimate(@cart.subtotal, @applicable_rates)

    @order = Order.new
    @order.build_from_cart(@cart, @shipping_country, @shipping_estimate)

    unless @shipping_country
      flash.now.alert = "#{t 'theme.cart.no_shipping_in_country', default: 'Sorry, we cannot proceed with your order as we currently do not ship to'} #{Country[@cart.shipping_address.country].name}"
    end
	end

	def create
    @cart = current_cart
		@order = Order.new(safe_params)
    @order.client_id = current_user.id if current_user
    @order.remote_ip = request.remote_ip

    @shipping_country = ShippingCountry.find_by_country(@cart.shipping_address.country) || ShippingCountry.find_by_country('WORLDWIDE')
    @shipping_estimate = ShippingRate.find(params[:shipping_rate])
    @order.build_from_cart(@cart, @shipping_country, @shipping_estimate)
    @order.copy_from_cart(@cart)

    respond_to do |format|
      if @order.save_with_payment(@cart)
        Cart.destroy(session[:cart_id])
        session[:cart_id] = nil
        auto_login(@order.client) unless current_user
        StoreMailer.order_receipt(@order).deliver
        AdminMailer.new_order(@order).deliver
        format.html { redirect_to @order, notice: "#{t 'theme.orders.thank_you', default: 'Thank you for your order'}." }
      else
        flash[:error] = "An error occured."
        format.html { redirect_to action: "new" }
      end
    end
	end

	def show
		@order = current_user.orders.find(params[:id])
	end

  private

    def safe_params
      params.require(:order).permit(:stripe_card_token)
    end

end