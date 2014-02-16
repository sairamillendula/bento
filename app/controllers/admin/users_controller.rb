class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [:toggle_status]
  set_tab :users

  def index
  	@users = User.admin.exclude_users([current_user.id]).order('first_name')
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(safe_params, as: :manager)
    random_password = SecureRandom.hex(4)
    @user.password = random_password
    @user.password_confirmation = random_password
    @user.admin = true

    respond_to do |format|
      if @user.save
        AdminMailer.new_admin_user(@user, random_password).deliver
        format.html { redirect_to admin_users_url, notice: "#{@user.full_name} #{t 'is_now_created', default: 'is created'}. #{t 'an_email_was_sent_to', default: 'An email was sent to'} #{@user.email}." }
      else
        format.html { render action: "new" }
      end
    end
  end

  def toggle_status
    @user.toggle_status
    render layout: false
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

    def safe_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :remember_me, :localization,
                                   :addresses_attributes, :reseller_request_attributes)

      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :remember_me, :localization,
                                   :addresses_attributes, :active, :admin, :reseller, :reseller_request_attributes, as: :manager)
    end

end