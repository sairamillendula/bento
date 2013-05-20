class Admin::OptionsController < Admin::BaseController
  before_filter :load_product

  def edit
    render :partial => 'modal_form', locals: {product: @product}
  end

  def update
    @product.update_attributes(params[:product])
    redirect_to [:edit, :admin, @product]
  end

private

  def load_product
    @product = Product.find(params[:product_id])
  end
end