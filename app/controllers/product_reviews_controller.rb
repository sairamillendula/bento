class ProductReviewsController < ApplicationController
  
	def create
    @review = ProductReview.new(safe_params)
    @review.user_id = current_user.id if current_user

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

  private

    def safe_params
      params.require(:product_review).permit(:username, :message, :product_id, :rating, :user_id, :approved)
    end

end