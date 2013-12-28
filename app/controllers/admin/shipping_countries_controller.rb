class Admin::ShippingCountriesController < Admin::BaseController
  before_action :set_shipping_country, only: [:edit, :update, :destroy]
  set_tab :shipping_rates

  def index
    @shipping_countries = ShippingCountry.includes(:rates).order(:country)
  end

  def new
    @shipping_country = ShippingCountry.new
  end

  def create
    @shipping_country = ShippingCountry.new(safe_params)

    respond_to do |format|
      if @shipping_country.save
        format.html { redirect_to edit_admin_shipping_country_url(@shipping_country), notice: 'Shipping country was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @shipping_country.update_attributes(safe_params)
        format.html { redirect_to admin_shipping_url, notice: 'Shipping country was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @shipping_country.destroy  
    redirect_to admin_shipping_url, notice: 'Shipping country was successfully removed.'
  end

  private

    def set_shipping_country
      @shipping_country = ShippingCountry.find(params[:id])
    end

    def safe_params
      params.require(:shipping_country).permit(:country, rates_attributes: [:id, :name, :criteria, :min_criteria, :max_criteria, :price, "_destroy"])
    end

end