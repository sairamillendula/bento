class CollectionsController < ApplicationController
  before_filter(only: [:show]) { @page_caching = true }
  caches_page :show

	def show
    @collection = Collection.friendly.includes(products: [:master]).find(params[:slug])
    @page_title       = "#{@collection.seo_title.present? ? @collection.seo_title : @collection.name} | #{t 'theme.site_name'}"
    @page_description = @collection.seo_description
    @products = @collection.products.visibles.order('position').page(params[:page]).per(12)
    @currency = session[:currency]

    if !@collection.visible?
      raise ActionController::RoutingError.new('Not Found')
    elsif request.path != "/collection/#{@collection.slug}"
      return redirect_to "/collection/#{@collection.slug}", status: :moved_permanently
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

end