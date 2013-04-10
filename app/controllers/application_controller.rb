class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :load_cart
  helper_method :current_cart

private

  def load_cart
    begin
      @cart = Cart.find(session[:cart_id])
    rescue ActiveRecord::RecordNotFound
      @cart = Cart.create
      session[:cart_id] = @cart.id
    end 
  end

  def not_authenticated
	  redirect_to login_url, alert: "#{t 'sessions.sign_in'}"
	end

	def current_cart
    @cart
  end

end