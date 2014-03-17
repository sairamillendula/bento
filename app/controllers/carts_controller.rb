class CartsController < ApplicationController

	def show
    @currency = session[:currency]
	end

  def update
    @cart.update_attributes(safe_params)
    @cart.calculate

    redirect_to cart_url
  end

  def apply_coupon
    @cart.apply_coupon(params[:coupon_code])
    redirect_to cart_url
  end

  def remove_coupon
    @cart.remove_coupon
    redirect_to cart_url
  end

	def destroy
    @cart.destroy
    session[:cart_id] = nil

    respond_to do |format|
      format.html { redirect_to cart_url }
    end
	end

  def checkout
    @cart = current_cart

    if @cart.items.empty?
      redirect_to products_url, notice: "#{t 'theme.cart.is_empty'}."
      return
    end
  end

  def continue
    # save user address
    @cart = current_cart

    if @cart.update_attributes(safe_params)
      if @cart.shipping_availability?
        redirect_to new_order_url
      else
        redirect_to checkout_cart_url, alert: "#{t 'theme.cart.no_shipping_in_country', default: 'Sorry, we cannot proceed with your order as we currently do not ship to'} #{Country[@cart.shipping_address.country].name}"
      end
    else
      render :checkout
    end
  end

  private

    def safe_params
      params.require(:cart).permit(:coupon_code, :email, :first_name, :last_name, :billing_address_attributes, :shipping_address_attributes, items_attributes: [:id, :quantity, :price],
                                   billing_address_attributes: [:id, :full_name, :address1, :address2, :city, :country, :postal_code, :province, :also_shipping_address],
                                   shipping_address_attributes: [:id, :full_name, :address1, :address2, :city, :country, :postal_code, :province] )
    end

end