class CategoriesController < ApplicationController

	def index
	  @categories = Category.order(:name)
    render json: @categories.tokens(params[:q])
	end

end