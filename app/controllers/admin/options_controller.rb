class Admin::OptionsController < Admin::BaseController
  before_action :load_product

  def edit
    render partial: 'modal_form', locals: {product: @product}
  end

  def update
    @product.update_attributes(safe_params)
  end

  private

    def load_product
      @product = Product.friendly.find(params[:product_id])
    end

    def safe_params
      params.require(:product).permit(options_attributes: [:id, :name, :product, :values, :position, "_destroy"])
    end

end
