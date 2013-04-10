class OrdersController < ApplicationController
  before_filter :require_login, only: [:index, :show]

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
    @order.add_items_from_cart(current_cart)
    @order.user_id = current_user.id if current_user

    respond_to do |format|
      if @order.save
        Cart.destroy(session[:cart_id])
        session[:cart_id] = nil
        format.html { redirect_to order_url(@order), notice: "#{t 'orders.thank_you'}." }
      else
        format.html { render action: "new" }
      end
    end
	end

	def show
		@order = current_user.orders.find(params[:id])
	end
end