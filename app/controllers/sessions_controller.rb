class SessionsController < ApplicationController
	#layout "login"

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
	  		redirect_to new_order_url
	  	else
				if user.admin?
			    redirect_to admin_dashboard_url, notice: "#{t 'sessions.signed_in'}"
			  elsif user.reseller?
		      redirect_to reseller_dashboard_url, notice: "#{t 'sessions.signed_in'}"
			  else
			  	redirect_back_or_to root_url, notice: "#{t 'sessions.signed_in'}"	  	
			  end
			end
		else
			flash.now.alert = "#{t 'sessions.error'}"
			if params[:checkout]
				render template: "carts/checkout"
			else
	    	render :new
	    end
	  end
	end

	def destroy
	  logout
	  redirect_to root_url, notice: "#{t 'sessions.signed_out'}."
	end
end