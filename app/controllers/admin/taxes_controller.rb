class Admin::TaxesController < Admin::BaseController
  set_tab :taxes

  def index
    @taxes = Tax.includes(:region_taxes, :shipping_country).all
  end

  def show
    @tax = Tax.find(params[:id])
  end

  def update
    @tax = Tax.find(params[:id])

    respond_to do |format|
      if @tax.update_attributes(params[:tax])
        format.html { redirect_to admin_taxes_url, notice: 'Tax was successfully updated.' }
      else
        format.html { render action: "show" }
      end
    end
  end

end