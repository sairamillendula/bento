class Reseller::CartsController < Reseller::BaseController
  set_tab :orders

  def new
    @cart = @current_user.carts.find(session[:reseller_cart_id])

    unless @cart.items.any?
      # @products = Product.visibles.includes(:variants).order('name')
      @products = Collection.find_by(name: 'revendeur').products.order('position')
      @products.each do |product|
        @cart.items.build(
          variant_id: product.master.id,
          quantity: 0,
          price: product.master.reseller_price || product.master.price
        )
        if product.variants.any?
          product.variants.each do |variant|
            @cart.items.build(
              variant_id: variant.id,
              quantity: 0,
              price: variant.reseller_price || variant.price
            )
          end
        end
      end
    end
  end

  def update
    @cart = @current_user.carts.find(session[:reseller_cart_id])
    respond_to do |format|
      @cart.billing_address.bypass_validation = true
      @cart.shipping_address.bypass_validation = true
      if @cart.update_attributes(safe_params)

        @cart.items.each do |item|
          item.update_attribute('price', item.variant.reseller_price || item.variant.price)
        end

        @cart.calculate
        format.html { redirect_to new_reseller_order_url }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def destroy
    @current_user.carts.find(session[:reseller_cart_id]).destroy
    respond_to do |format|
      format.html { redirect_to reseller_orders_url }
    end
  end

  private

    def safe_params
      params.require(:cart).permit(items_attributes: [:id, :quantity, :variant_id])
    end
end