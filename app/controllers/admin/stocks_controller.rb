class Admin::StocksController < Admin::BaseController
  set_tab :stocks

  def show
    @products = Product.includes(:variants)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @stocks }
    end
  end

  def update
    begin
      params[:stocks].values.first.values.each do |product_params|
        Product.find(product_params.delete(:id)).update_attributes!(product_params)
      end
    rescue
      return redirect_to [:admin, :stocks], alert: "Failed to update stocks. Please check input."
    end
    
    return redirect_to [:admin, :stocks], notice: "Stocks were successfully updated."
  end

end