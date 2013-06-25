class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :load_cart
  before_filter :set_locale

  helper_method :current_cart

  http_basic_authenticate_with name: "temp", password: "temp" if Rails.env.production?

private

  def set_locale
    I18n.locale = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first || I18n.default_locale
  end

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