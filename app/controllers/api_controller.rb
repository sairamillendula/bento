class ApiController < ApplicationController
  def google_shopping
  	@products = Product.visibles
  	host_with_port = request.protocol + request.host_with_port

    respond_to do |format|
	    format.csv { send_data @products.to_csv(host_with_port) }
	  end
  end
end