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
        # only ratio with id or star present is applicable to proceed
        # unless ratio_params.select{|k, v| k =~ /^(star|id)/ && !v.empty?}.empty?
        #   ratio = Ratio.find_by_id(ratio_params.delete(:id)) || Ratio.new
        #   ratio.update_attributes!(ratio_params)
        # end
      end
    rescue
      return redirect_to [:admin, :stocks], alert: "Failed to update stocks. Please check inputs."
    end
    
    return redirect_to [:admin, :stocks], notice: "Stocks successfully updated."
  end

end