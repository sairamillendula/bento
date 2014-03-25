class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:webhook]

  def google_shopping
  	@products = Product.visibles
  	host_with_port = request.protocol + request.host_with_port

    respond_to do |format|
	    format.csv { send_data @products.to_csv(host_with_port) }
	  end
  end

  def sitemap
  	@pages = Page.visibles
  	@articles = Article.visibles
  	@products = Product.visibles

  	respond_to do |format|
	    format.xml #{ render xml: @products }
	    # render(:template => “reports/report”, :formats => [:xml], :handlers => :builder, :layout => false)
	  end
  end
end