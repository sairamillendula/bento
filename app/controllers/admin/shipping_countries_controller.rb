class Admin::ShippingCountriesController < Admin::BaseController
  set_tab :shipping_rates

  def index
    @shipping_countries = ShippingCountry.includes(:rates).order(:country)
  end

  def new
    @shipping_country = ShippingCountry.new
  end

  def create
    @shipping_country = ShippingCountry.new(params[:shipping_country])

    respond_to do |format|
      if @shipping_country.save
        format.html { redirect_to edit_admin_shipping_country_url(@shipping_country), notice: 'Shipping country was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def edit
    @shipping_country = ShippingCountry.find(params[:id])
  end

  def update
    @shipping_country = ShippingCountry.find(params[:id])

    respond_to do |format|
      if @shipping_country.update_attributes(params[:shipping_country])
        format.html { redirect_to admin_shipping_url, notice: 'Shipping country was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @shipping_country = ShippingCountry.find(params[:id])
    @shipping_country.destroy

    redirect_to admin_shipping_url, notice: 'Shipping country was successfully removed.'
  end

end