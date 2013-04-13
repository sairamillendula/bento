class PagesController < ApplicationController
  
  #before_filter(only: [:index, :show]) { @page_caching = true }
  before_filter { @page_caching = true }
  caches_page :home, :show

	def show
    @page = Page.includes(:meta_tag).find(params[:slug])
    @page_title       = "#{@page.meta_tag.title.present? ? @page.meta_tag.title : @page.name} | #{t 'site_name'}"
    @page_description = @page.meta_tag.description

    if !@page.public?
      raise ActionController::RoutingError.new('Not Found')
    elsif request.path != "/#{@page.slug}"
      redirect_to "/#{@page.slug}", status: :moved_permanently
    end
  end

  def home
    @products = Product.public.in_stocks.order('name')
  end

  def become_reseller
    @reseller_request = ResellerRequest.new if current_user
  end

end