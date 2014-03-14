class RegistrationsController < ApplicationController
  before_filter :require_login, only: [:edit, :update]

  def new
    @user = User.new
  end

  def create
	  @user = User.new(safe_params)

	  if @user.save
	  	auto_login(@user)
      UserMailer.welcome(@user).deliver
      if params[:checkout]
        redirect_to checkout_cart_url
      elsif params[:become_reseller]
        redirect_to become_reseller_url
      else
	  	  redirect_to products_url, notice: "#{t 'theme.registrations.welcome', default: 'Thanks for signing up!' }"
      end
	  else
      if params[:checkout]
        render template: "carts/checkout"
      else
	     render :new
     end
	  end
	end

	def edit
		@user = current_user
	end

	def update
    if params[:user][:password].blank?
      params[:user].delete("password")
      params[:user].delete("password_confirmation")
    end

    @user = User.find(current_user.id)

    respond_to do |format|
      if @user.update_attributes(safe_params)
        format.html { redirect_to profile_url, notice: "#{t 'theme.registrations.profile_updated', default: 'Profile was successfully updated'}." }
      else
        format.html { render action: "edit" }
      end
    end
	end

  private

    def safe_params
      params.require(:user).permit(:email, :first_name, :last_name, :password, :password_confirmation)
    end

end