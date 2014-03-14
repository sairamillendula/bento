class PagesController < ApplicationController
  skip_before_filter :load_cart, only: [:user_info]

  #before_filter(only: [:index, :show]) { @page_caching = true }
  before_filter(except: [:home]) { @page_caching = false }
  caches_page :show

	def show
    @page = Page.friendly.find(params[:slug])
    @page_title       = "#{@page.seo_title.present? ? @page.seo_title : @page.name} | #{t 'theme.site_name'}"
    @page_description = @page.seo_description

    if !@page.visible?
      raise ActionController::RoutingError.new('Not Found')
    elsif request.path != "/#{@page.slug}"
      redirect_to "/#{@page.slug}", status: :moved_permanently
    end
  end

  def home
    #@products = Product.visibles.order('name').page(params[:page]).per(12)
    @products = Collection.first.products.visibles.includes(:pictures).order('position').page(params[:page]).per(12)
    @currency = session[:currency]

    respond_to do |format|
      format.html
      format.js
    end
  end

  def become_reseller
    @reseller_request = ResellerRequest.new
  end

end