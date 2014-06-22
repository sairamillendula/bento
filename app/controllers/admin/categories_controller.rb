class Admin::CategoriesController < Admin::BaseController
  before_action :set_category, only: [:edit, :update, :destroy]
  set_tab :categories
  helper_method :sort_column, :sort_direction

  def index
    @categories = Category.includes(:products).order(sort_column + " " + sort_direction).page(params[:page]).per(20)
  end

  def edit
  end

  def update
    respond_to do |format|
      if @category.update_attributes(safe_params)
        format.html { redirect_to admin_categories_url, notice: 'Category was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @category.destroy
    respond_to do |format|
      format.html { redirect_to admin_categories_url, notice: 'Category was successfully deleted.' }
    end
  end

  private

    def safe_params
      params.require(:category).permit(:name, :description, :seo_title, :seo_description)
    end

    def set_category
      @category = Category.find(params[:id])
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end

    def sort_column
      Category.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
    end

end