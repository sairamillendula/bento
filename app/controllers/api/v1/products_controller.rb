module Api
  module V1
    class ProductsController < Api::BaseController
      respond_to :json

      def index
        respond_with Product.visibles.includes(:variants, :pictures)
      end

      def show
        respond_with Product.find(params[:id])
      end
    end
  end
end