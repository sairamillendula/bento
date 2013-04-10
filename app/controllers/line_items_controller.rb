class LineItemsController < ApplicationController
  before_filter :load_cart

	def create
    product = Product.find(params[:product_id])
		@line_item = @cart.add_to_cart(product)
		
		respond_to do |format|
			if @line_item.save
        format.html { redirect_to cart_path, notice: 'Product successfully added to cart.' }
        format.js
      else
        format.html { render action: "new" }
        format.js
      end
    end
	end

	def update
		
	end

	def destroy
    @cart.remove_from_cart(params[:id])

		respond_to do |format|
      format.html { redirect_to cart_url, notice: 'Product successfully removed from cart.' }
      format.js
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