class CartsController < ApplicationController

	def show
	end

  def update
    @cart.update_attributes(params[:cart])        
    @cart.calculate

    redirect_to cart_url
  end

  def apply_coupon
    @cart.apply_coupon(params[:coupon_code])
    redirect_to cart_url
  end

  def remove_coupon
    @cart.remove_coupon
    redirect_to cart_url
  end

	def destroy
    @cart.destroy
    session[:cart_id] = nil

    respond_to do |format|
      format.html { redirect_to cart_url }
    end
	end

  def checkout
    @cart = current_cart
    
    if @cart.items.empty?
      redirect_to products_url, notice: "#{t 'cart.is_empty'}."
      return
    end
  end

  def continue
    # save user address
    @cart = current_cart

    if @cart.update_attributes(params[:cart])
      if @cart.shipping_availability?
        redirect_to new_order_url
      else
        redirect_to checkout_cart_url, alert: "#{t 'cart.no_shipping_in_country'} #{Country[@cart.shipping_address.country].name}"
      end
    else
      render :checkout
    end
  end

end