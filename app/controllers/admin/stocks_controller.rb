class Admin::StocksController < Admin::BaseController
  set_tab :stocks

  def index
    @stocks = Stock.group(:product_id)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @stocks }
    end
  end

  def update_multiple
    @stocks = Stock.update(params[:stocks].keys, params[:stocks].values)
    @stocks.reject! { |s| s.errors.empty? }
    if @stocks.empty?
      redirect_to admin_stocks_url
    else
      render "index"
    end
  end

end