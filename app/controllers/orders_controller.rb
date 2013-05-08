class OrdersController < ApplicationController
  before_filter :require_login, only: [:index, :show]
  before_filter(only: [:new, :create, :show]) { @checkout_script = true }

  def index
  	@orders = current_user.orders.order('created_at DESC')
  end

	def new
		@cart = current_cart

    if @cart.items.empty?
      redirect_to products_url, notice: "#{t 'carts.is_empty'}."
      return
    end

    @shipping_country = ShippingCountry.find_by_country(@cart.shipping_address.country) || ShippingCountry.find_by_country('Worldwide')
    @shipping_rates = (@shipping_country && @shipping_country.rates.order('price ASC')) || []
    @shipping_estimate = ShippingRate.estimate(@cart.subtotal, @shipping_rates)

    @order = Order.new
    @order.build_from_cart(@cart, @shipping_country, @shipping_estimate)

    unless @shipping_country
      flash.now.alert = "Sorry, your order cannot complete. We don't ship to #{Country[@cart.shipping_address.country].name}"
    end
	end

	def create
    @cart = current_cart
		@order = Order.new(params[:order])
    @order.user_id = current_user.id if current_user
    @order.remote_ip = request.remote_ip

    @shipping_country = ShippingCountry.find_by_country(@cart.shipping_address.country) || ShippingCountry.find_by_country('Worldwide')
    @shipping_estimate = ShippingRate.find(params[:shipping_rate])
    @order.build_from_cart(@cart, @shipping_country, @shipping_estimate)
    @order.copy_from_cart(@cart)

    respond_to do |format|
      if @order.save_with_payment(@cart)
        Cart.destroy(session[:cart_id])
        session[:cart_id] = nil
        format.html { redirect_to @order, notice: "#{t 'orders.thank_you'}." }
        # TODO send email
      else
        format.html { redirect_to action: "new" }
      end
    end
	end

	def show
		@order = current_user.orders.find(params[:id])
	end
end