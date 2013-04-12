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

end