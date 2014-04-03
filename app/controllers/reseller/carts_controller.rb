class Reseller::CartsController < Reseller::BaseController
  set_tab :orders
  # helper_method :sort_column, :sort_direction

  def new
    @cart = Cart.new

    @products = Product.includes(:variants).order('name')
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
              price: variant.reseller_price || product.master.price
          )
        end
      end
    end
  end

  def create
    @cart = @current_user.carts.new(safe_params)

    country_alpha2 = Country.find_country_by_name(@current_user.reseller_request.country).alpha2 rescue nil
    @cart.build_shipping_address(
        full_name: @current_user.reseller_request.business_name,
        country: country_alpha2,
        city: @current_user.reseller_request.city,
        bypass_validation: true
    )
    @cart.build_billing_address(
        full_name: @current_user.reseller_request.business_name,
        country: country_alpha2,
        city: @current_user.reseller_request.city,
        bypass_validation: true
    )

    respond_to do |format|
      if @cart.save
         @cart.calculate
        session[:cart_id] = @cart.id
        format.html { redirect_to new_reseller_order_url }
      else
        format.html { render action: 'new' }
      end
    end
  end




  private

    def safe_params
      params.require(:cart).permit(items_attributes: [:id, :quantity, :price, :variant_id])
    end
end