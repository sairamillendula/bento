class ApplicationController < ActionController::Base
  protect_from_forgery

private

  def not_authenticated
	  redirect_to login_url, alert: "#{t 'sessions.sign_in'}"
	end

	def current_cart
		current_cart = Cart.find(session[:cart_id])
  rescue ActiveRecord::RecordNotFound
  	cart = Cart.create
  	session[:cart_id] = cart.id
    current_cart = cart
  end

end