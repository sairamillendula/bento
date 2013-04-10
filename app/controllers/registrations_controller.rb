class RegistrationsController < ApplicationController
  before_filter :require_login, only: [:edit, :update]
  #layout "login"

  def new
    @user = User.new
  end

  def create
	  @user = User.new(params[:user])

	  if @user.save
	  	auto_login(@user)
	  	redirect_to products_url, notice: "#{t 'registrations.success'}"
	    UserMailer.welcome(@user).deliver
	  else
	    render :new
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
      if @user.update_attributes(params[:user])
        format.html { redirect_to profile_url, notice: 'Profile was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
	end

end