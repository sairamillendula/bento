class PagesController < ApplicationController
  
  #before_filter(only: [:index, :show]) { @page_caching = true }
  before_filter { @page_caching = true }
  caches_page :home, :show

	def show
    @page = Page.find(params[:slug])
    @page_title       = "#{@page.seo_title.present? ? @page.seo_title : @page.name} | #{t 'site_name'}"
    @page_description = @page.seo_description

    if !@page.visible?
      raise ActionController::RoutingError.new('Not Found')
    elsif request.path != "/#{@page.slug}"
      redirect_to "/#{@page.slug}", status: :moved_permanently
    end
  end

  def home
    @page_title       = "#{t 'site_slogan'} | #{t 'site_name'}"
    @page_description = "#{t 'site_description'}"
    @products = Product.visibles.in_stocks.order('name')
  end

  def become_reseller
    @reseller_request = ResellerRequest.new if current_user
  end

end