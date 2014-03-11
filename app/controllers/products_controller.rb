class ProductsController < ApplicationController
  before_filter(only: [:index, :show]) { @page_caching = true }
  caches_page :index, :show
  set_tab :products

  def index
    if params[:category]
      @category = Category.where(name: params[:category]).first

      if @category.present?
        @page_title = "#{params[:category]} | #{t 'theme.site_name'}"
        @products = @category.products.visibles.order('name').page(params[:page]).per(12)
      else
        raise ActionController::RoutingError.new('Not Found')
      end
    else
      @page_title = "#{I18n.t 'products.title'} | #{t 'theme.site_name'}"
      @products = Product.visibles.order('name').page(params[:page]).per(12)
    end
    @currency = cookies[:currency]

    respond_to do |format|
      format.html
      format.js
    end
  end

	def show
    @product = Product.friendly.includes(:pictures, :variants).find(params[:id])
    @page_title       = "#{@product.seo_title.present? ? @product.seo_title : @product.name} | #{t 'theme.site_name'}"
    @page_description = @product.seo_description

    @currency = cookies[:currency]

    if !@product.visible?
      raise ActionController::RoutingError.new('Not Found')
    elsif request.path != "/products/#{@product.slug}"
      redirect_to "/products/#{@product.slug}", status: :moved_permanently
    end
  end

  def search
    @products = Product.where("lower(name) like ?", "%#{params[:q].strip.downcase}%")
    @currency = cookies[:currency]

    respond_to do |format|
      format.json {render json: @products}
    end
  end

end