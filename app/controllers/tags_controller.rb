class TagsController < ApplicationController

	def index
	  @tags = Tag.order(:name)
    render json: @tags.tokens(params[:q])
	end

end