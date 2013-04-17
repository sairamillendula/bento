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

    @order = Order.new
    @order.build_client unless current_user
    @order.build_shipping_address
    @order.build_billing_address
	end

	def create
		@order = Order.new(params[:order])
    @order.user_id = current_user.id if current_user
    @order.remote_ip = request.remote_ip

    respond_to do |format|
      if @order.save_with_payment(current_cart.total)
        @order.add_items_from_cart(current_cart)
        Cart.destroy(session[:cart_id])
        session[:cart_id] = nil
        format.html { redirect_to @order, notice: "#{t 'orders.thank_you'}." }
        # TODO send email
      else
        format.html { render action: "new" }
      end
    end
	end

	def show
		@order = current_user.orders.find(params[:id])
	end
end