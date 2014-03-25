class LineItemsController < ApplicationController
  skip_before_action :verify_authenticity_token

	def create
    variant = ProductVariant.find(params[:product_variant_id])
    puts variant.inspect
		@line_item = @cart.add_to_cart(variant)

		respond_to do |format|
			if @line_item.kind_of?(LineItem) && @line_item.save
        format.html { redirect_to cart_path }
        format.js
      else
        format.html {
          # line item is 'out of stock' string
          redirect_to cart_path, alert: @line_item
        }
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