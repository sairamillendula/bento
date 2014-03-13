class Admin::ResellersController < Admin::BaseController
  before_action :set_reseller, only: [:toggle_reseller_status]
  set_tab :resellers
  
  def index
  	@users = User.resellers.order('first_name')
  end

  def show
    @user = User.includes(:reseller_request).find(params[:id])
  end

  def toggle_reseller_status
    @user.toggle_reseller_status

    respond_to do |format|
      if @user.reseller?
        format.html { redirect_to admin_resellers_url, notice: "#{@user.full_name} reseller account was approved. Confirmation sent to #{@user.email}" }
        format.js
        ResellerMailer.reseller_request_approved(@user).deliver
      else
        format.html { redirect_to admin_resellers_url, notice: "#{@user.full_name} #{t 'is_now_deactivated', default: 'is deactivated'}." }
        format.js
      end
    end
  end

  def catalogue
    set_tab :resellers_catalogue
    @products = Product.visibles.order('name')
  end

  private

    def set_reseller
      @user = User.find(params[:id])
    end

end