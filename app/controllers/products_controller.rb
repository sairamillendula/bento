class ProductsController < ApplicationController
  before_filter(only: [:index, :show]) { @page_caching = true }
  caches_page :index, :show
  set_tab :products

  def index
    if params[:category]
      @page_title = "#{params[:category]} | #{t 'site_name'}"

      @category = Category.find_by_name(params[:category])
      @products = @category.products.public.order('name').page(params[:page]).per(10)
    else
      @page_title = "#{I18n.t 'products.title'} | #{t 'site_name'}"
      @products = Product.public.order('name').page(params[:page]).per(10)
    end
  end

	def show
    @product = Product.includes(:meta_tag, :categories).find(params[:id])
    @page_title       = "#{@product.meta_tag.title.present? ? @product.meta_tag.title : @product.name} | #{t 'site_name'}"
    @page_description = @product.meta_tag.description
    
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