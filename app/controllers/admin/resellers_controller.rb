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

    if @user.reseller?
      ResellerMailer.reseller_request_approved(@user).deliver
      redirect_to admin_resellers_url, notice: "#{@user.full_name} reseller account was approved. Confirmation sent to #{@user.email}"
    else  
      redirect_to admin_resellers_url, notice: "#{@user.full_name} #{t 'is_now_deactivated', default: 'is deactivated'}."
    end
  end

  private

    def set_reseller
      @user = User.find(params[:id])
    end

end