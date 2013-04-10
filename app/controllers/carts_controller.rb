class CartsController < ApplicationController

	def show
	end

  def update
    @cart.update_attributes(params[:cart])        
    @cart.calculate

    redirect_to cart_url, notice: "#{t 'carts.is_updated'}."
  end

	def destroy
    @cart.destroy
    session[:cart_id] = nil

    respond_to do |format|
      format.html { redirect_to cart_url, notice: "#{t 'carts.is_empty'}." }
    end
	end

end