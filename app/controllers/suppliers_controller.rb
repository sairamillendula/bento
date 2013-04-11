class SuppliersController < ApplicationController

	def index
	  @suppliers = Supplier.order(:name)
    render json: @suppliers.tokens(params[:q])
	end

end