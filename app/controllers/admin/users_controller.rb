class Admin::UsersController < Admin::BaseController
  set_tab :users
  
  def index
  	@users = User.admin.exclude_users([current_user.id]).order('first_name')
  end
  
  def new
    @user = User.new(params[:user], as: :manager)
  end

  def create
    @user = User.new(params[:user], as: :manager)
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

  def deactivate
    @user = User.find(params[:id])
    @user.active = false

    if @user.save
      redirect_to admin_users_url, notice: "#{@user.full_name} #{t 'is_now_inactive', default: 'is inactive'}."
    else
      redirect_to admin_users_url, alert: "Cannot deactivate user #{@user.full_name}. Please contact system administrator."
    end
  end

  def activate
    @user = User.find(params[:id])
    @user.active = true

    if @user.save
      redirect_to admin_users_url, notice: "#{@user.full_name} #{t 'is_now_active', default: 'is activate'}."
    else
      redirect_to admin_users_url, alert: "Cannot activate user #{@user.full_name}. Please contact system administrator."
    end
  end

end