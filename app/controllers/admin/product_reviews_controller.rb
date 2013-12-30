class Admin::ProductReviewsController < Admin::BaseController
  before_action :set_review, only: [:toggle_product_review_status]
  set_tab :reviews
  
  def index
  	@reviews = ProductReview.includes(:product, :user).order(sort_column + " " + sort_direction).page(params[:page]).per(10)
  end
  
  def show
  end

  def toggle_product_review_status
    @review.toggle_product_review_status

    if @review.approved?
      redirect_to admin_product_reviews_url, notice: "#{t 'reviews.is_now_approved'}."
    else
      redirect_to admin_product_reviews_url, notice: "#{t 'reviews.is_now_disapproved'}."
    end
  end

  private

    def set_review
      @review = ProductReview.find(params[:id])
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end

    def sort_column
      ProductReview.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
    end

end