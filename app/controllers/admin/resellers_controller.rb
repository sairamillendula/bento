class Admin::ResellersController < Admin::BaseController
  set_tab :resellers
  
  def index
  	@users = User.resellers.order('first_name')
  end

  def show
    @user = User.includes(:reseller_request).find(params[:id])
  end

  def disapprove
    @user = User.find(params[:id])
    @user.reseller = false

    if @user.save
      redirect_to admin_resellers_url, notice: "#{@user.full_name} #{t 'is_now_deactivated', default: 'is deactivated'}."
    else
      redirect_to admin_resellers_url, alert: "Cannot deactivate user #{@user.full_name}. Please contact system administrator."
    end
  end

  def approve
    @user = User.find(params[:id])
    @user.reseller = true

    if @user.save
      redirect_to admin_resellers_url, notice: "#{@user.full_name} is now approved. Confirmation sent to #{@user.email}"
      ResellerMailer.reseller_request_approved(@user).deliver
    else
      redirect_to admin_resellers_url, alert: "Cannot activate user #{@user.full_name}. Please contact system administrator."
    end
  end

end