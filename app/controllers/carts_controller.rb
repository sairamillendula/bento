class CartsController < ApplicationController
	def show
		begin
      @cart = current_cart
    rescue ActiveRecord::RecordNotFound
      logger.error "Attempt to access invalid cart #{params[:id]}"
      redirect_to root_url, notice: "#{t 'carts.invalid'}"
    else
      respond_to do |format|
        format.html # show.html.erb
      end
    end
	end

	def destroy
		@cart = current_cart
    @cart.destroy
    session[:cart_id] = nil

    respond_to do |format|
      format.html { redirect_to products_url, notice: "#{t 'carts.is_empty'}." }
    end
	end
end