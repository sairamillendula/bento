class ShippingsController < ApplicationController

  def search
    @shipping_rates = nil
    @currency = session[:currency]
    @country = params[:shipping][:country]
    if @country.present?
      shipping_country = ShippingCountry.find_by_country(@country) || ShippingCountry.find_by_country('WORLDWIDE')
      @shipping_rates = shipping_country && shipping_country.rates.order('price ASC')
      @shipping_estimate = ShippingRate.estimate(BigDecimal.new(params[:shipping][:subtotal]), @shipping_rates)
    end
  end

end