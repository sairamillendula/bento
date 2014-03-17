module Api
  module V1
    class ProductsController < Api::BaseController
      respond_to :json

      # curl http://localhost:3015/api/products -H "Content-type: application/json" -H 'Authorization: Token token="b76cdabd077990df5d2f2b0679e316c2"'
      def index
        respond_with Product.visibles.includes(:variants, :pictures)
      end

      # curl http://localhost:3015/api/products/:id -H "Content-type: application/json" -H 'Authorization: Token token="b76cdabd077990df5d2f2b0679e316c2"'
      # curl http://localhost:3015/api/products/:slug -H "Content-type: application/json" -H 'Authorization: Token token="b76cdabd077990df5d2f2b0679e316c2"'
      def show
        @product = Product.friendly.includes(:pictures, :variants).find(params[:id])
        respond_with :api, @product
      end

    end
  end
end