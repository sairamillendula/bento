class ProductsController < ApplicationController
  before_filter(only: [:index, :show]) { @page_caching = true }
  caches_page :index, :show
  set_tab :products

  def index
    if params[:category]
      @category = Category.find_by_name(params[:category])
      @products = @category.products.public.order('name').page(params[:page]).per(10)
    else
      @products = Product.public.order('name').page(params[:page]).per(10)
    end
  end

	def show
    @product = Product.find(params[:id])
    
    if !@product.public?
      raise ActionController::RoutingError.new('Not Found')
    elsif request.path != "/products/#{@product.slug}"
      redirect_to "/products/#{@product.slug}", status: :moved_permanently
    end
  end

  def search
    @products = Product.where("name like ?", "%#{params[:q]}%")

    respond_to do |format| 
      format.json {render json: @products}
    end
  end

end