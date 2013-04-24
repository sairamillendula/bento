class Admin::ShippingCountriesController < Admin::BaseController
  set_tab :shipping_rates

  def index
    @shipping_countries = ShippingCountry.includes(:rates).order('created_at DESC')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @shipping_countries }
    end
  end

  def new
    @shipping_country = ShippingCountry.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @shipping_country }
    end
  end

  def create
    @shipping_country = ShippingCountry.new(params[:shipping_country])

    respond_to do |format|
      if @shipping_country.save
        format.html { redirect_to edit_admin_shipping_country_url(@shipping_country), notice: 'Shipping country was successfully created.' }
        format.json { render json: @shipping_country, status: :created, location: @shipping_country }
      else
        format.html { render action: "new" }
        format.json { render json: @shipping_country.errors, status: :unprocessable_entity }
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
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @shipping_country.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @shipping_country = ShippingCountry.find(params[:id])
    @shipping_country.destroy

    redirect_to admin_shipping_url, notice: 'Shipping country was successfully removed.'
  end

end