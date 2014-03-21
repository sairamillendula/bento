module Api
  module V1
    class ProductsController < Api::BaseController
      respond_to :json

      # curl http://localhost:3015/api/products -H "Content-type: application/json" -H 'Authorization: Token token="b76cdabd077990df5d2f2b0679e316c2"'
      def index
        @products = Product.visibles.includes(:master, :variants, :main_picture)
      end

      # curl http://localhost:3015/api/products/:id -H "Content-type: application/json" -H 'Authorization: Token token="b76cdabd077990df5d2f2b0679e316c2"'
      # curl http://localhost:3015/api/products/:slug -H "Content-type: application/json" -H 'Authorization: Token token="b76cdabd077990df5d2f2b0679e316c2"'
      # on production, response is {"status":"404","error":"Not Found"}
      def show
        @product = Product.friendly.includes(:master, :variants, :main_picture).find(params[:id])
      end

    end
  end
end