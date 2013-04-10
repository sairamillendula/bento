class LineItemsController < ApplicationController

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
end