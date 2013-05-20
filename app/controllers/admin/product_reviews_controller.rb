class Admin::ProductReviewsController < Admin::BaseController
  set_tab :reviews
  
  def index
  	@reviews = ProductReview.order(sort_column + " " + sort_direction).page(params[:page]).per(10)
  end
  
  def show
  end

  def approve
    @review = ProductReview.find(params[:id])
    @review.approved = true

    if @review.save
      redirect_to admin_product_reviews_url, notice: "#{t 'reviews.is_now_approved'}."
    else
      redirect_to admin_product_reviews_url, alert: "Cannot approve review. Please contact system administrator."
    end
  end

  def disapprove
    @review = ProductReview.find(params[:id])
    @review.approved = false

    if @review.save
      redirect_to admin_product_reviews_url, notice: "#{t 'reviews.is_now_disapproved'}."
    else
      redirect_to admin_product_reviews_url, alert: "Cannot disapprove review. Please contact system administrator."
    end
  end

private

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

  def sort_column
    ProductReview.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end

end