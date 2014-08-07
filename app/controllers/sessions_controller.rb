class SessionsController < ApplicationController

	def new
	end

  def create
	  if params[:session]
	    user = login(params[:session][:email], params[:session][:password], params[:session][:remember_me])
	  else
	  	user = login(params[:email], params[:password], params[:remember_me])
	  end

	  if user
	  	if params[:checkout]
	  		redirect_to checkout_cart_url
	  	elsif params[:become_reseller]
	  		redirect_to become_reseller_url
	  	else
				if user.admin?
			    redirect_to admin_dashboard_url
			  elsif user.active_reseller?
		      redirect_to reseller_dashboard_url
			  else
			  	redirect_back_or_to root_url
			  end
			end
			current_cart.update_attributes(user_id: user.id)
		else
			flash.now.alert = "#{t 'theme.sessions.error', default: 'Invalid email/password combination'}."
			if params[:checkout]
				render template: "carts/checkout"
			else
	    	render :new
	    end
	  end
	end

	def destroy
	  logout
	  redirect_to root_url, notice: "#{t 'theme.sessions.signed_out', default: 'Signed out'}."
	end
end