class CollectionsController < ApplicationController
  before_filter(only: [:show]) { @page_caching = true }
  caches_page :show

	def show
    @collection = Collection.includes(:products).find(params[:slug])
    @page_title       = "#{@collection.seo_title.present? ? @collection.seo_title : @collection.title} | #{t 'site_name'}"
    @page_description = @collection.seo_description
    
    if !@collection.visible?
      raise ActionController::RoutingError.new('Not Found')
    elsif request.path != "/collection/#{@collection.slug}"
      redirect_to "/collection/#{@collection.slug}", status: :moved_permanently
    end
  end

end