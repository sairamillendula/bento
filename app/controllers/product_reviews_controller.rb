class ProductReviewsController < ApplicationController
  


	def create
    #@product = Product.find(params[:slug])
    #@product = Product.find(:product_id)
    @review = ProductReview.new(params[:product_review])
    @review.user_id = current_user.id if current_user
    #@review.product_id = Product.find(params[:id]).id

    respond_to do |format|
      if @review.save
        format.html { redirect_to product_url(:product_id) }
        format.js
      else
        format.html { redirect_to product_url(@product.slug) }
        format.js
      end
    end
  end

end