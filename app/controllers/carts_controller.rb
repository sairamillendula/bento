class CartsController < ApplicationController
  before_filter :load_cart

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

  private

  def load_cart
    begin
      @cart = current_cart
    rescue ActiveRecord::RecordNotFound
      logger.error "Attempt to access invalid cart #{params[:id]}"
      return redirect_to root_url, notice: "#{t 'carts.invalid'}"
    end 
  end
end