class Admin::TaxesController < Admin::BaseController
  before_action :set_tax, only: [:show, :update]
  set_tab :taxes

  def index
    @taxes = Tax.includes(:region_taxes, :shipping_country).all
  end

  def show
  end

  def update
    respond_to do |format|
      if @tax.update_attributes(safe_params)
        format.html { redirect_to admin_taxes_url, notice: 'Tax was successfully updated.' }
      else
        format.html { render action: "show" }
      end
    end
  end

  private

    def set_tax
      @tax = Tax.find(params[:id])
    end

    def safe_params
      params.require(:tax).permit(:name, :rate, :region_taxes_attributes)
    end

end