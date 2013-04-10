class LineItemsController < ApplicationController

	def create
		@cart = current_cart
    product = Product.find(params[:product_id])
		@line_item = @cart.add_product(product.id)
		
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
		@cart = current_cart
		@item = @cart.items.find(params[:id])
		@item.destroy

		respond_to do |format|
      format.html { redirect_to cart_path }
      format.js
    end
	end
end