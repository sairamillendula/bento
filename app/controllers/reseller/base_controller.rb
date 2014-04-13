class Reseller::BaseController < ApplicationController
  layout 'reseller'
  before_filter :verify_reseller
  before_action :load_cart
  before_filter { @checkout_script = true }

private

  def verify_reseller
    redirect_to root_url unless current_user && current_user.reseller?
  end

  def load_cart
    begin
      @cart = @current_user.carts.find(session[:reseller_cart_id])
    rescue ActiveRecord::RecordNotFound
      @cart = Cart.create(user_id: current_user.id)
      session[:reseller_cart_id] = @cart.id
      country_alpha2 = Country.find_country_by_name(@current_user.reseller_request.country).alpha2 rescue nil
      @cart.create_shipping_address(
          full_name: @current_user.reseller_request.business_name,
          country: country_alpha2,
          city: @current_user.reseller_request.city,
          bypass_validation: true
      )
      @cart.create_billing_address(
          full_name: @current_user.reseller_request.business_name,
          country: country_alpha2,
          city: @current_user.reseller_request.city,
          bypass_validation: true
      )
    end
  end
end