class ProductsController < ApplicationController
  before_filter(only: [:index, :show]) { @page_caching = true }
  caches_page :index, :show
  set_tab :products

  def index
    if params[:category]
      @page_title = "#{params[:category]} | #{t 'site_name'}"

      @category = Category.find_by_name(params[:category])
      @products = @category.products.visibles.order('name').page(params[:page]).per(10)
    else
      @page_title = "#{I18n.t 'products.title'} | #{t 'site_name'}"
      @products = Product.visibles.order('name').page(params[:page]).per(10)
    end
  end

	def show
    @product = Product.includes(:categories).find(params[:id])
    @page_title       = "#{@product.seo_title.present? ? @product.seo_title : @product.name} | #{t 'site_name'}"
    @page_description = @product.seo_description
    
    if !@product.visible?
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