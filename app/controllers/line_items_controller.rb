class LineItemsController < ApplicationController

	def create
    variant = ProductVariant.find(params[:product_variant_id])
		@line_item = @cart.add_to_cart(variant)
		
		respond_to do |format|
			if @line_item.save
        format.html { redirect_to cart_path }
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
      format.html { redirect_to cart_url }
      format.js
    end
	end
  
  private

    def safe_params
      params.require(:line_item).permit(:cart_id, :variant_id, :quantity, :price, :order_id)
    end

end