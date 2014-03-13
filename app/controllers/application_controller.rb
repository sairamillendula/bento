class ApplicationController < ActionController::Base
  include ActionController::Caching::Pages
  self.page_cache_directory = "#{Rails.root.to_s}/public/cache"

  protect_from_forgery
  before_action :load_cart
  before_action :set_locale

  helper_method :current_cart

  #http_basic_authenticate_with name: "temp", password: "temp" if Rails.env.production?

  def set_currency
    begin
      Money.new(1000, ENV['STRIPE_CURRENCY'].upcase).exchange_to(params[:currency])
      session[:currency] = params[:currency]
    rescue Money::Bank::UnknownRate
      nil
    end
    render js: "window.location.reload()"
  end

  def get_total
    begin
      total = Money.new(params[:total].to_f * 100, ENV['STRIPE_CURRENCY'].upcase).exchange_to(params[:currency])
      session[:currency] = params[:currency]
    rescue Money::Bank::UnknownRate
      total = params[:total]
    end
    render json: [ {total: total.to_s, symbol: total.symbol, currency: session[:currency]}]
  end

  private

    def set_locale
      #I18n.locale = request.env['HTTP_ACCEPT_LANGUAGE'].try(:scan, /^[a-z]{2}/).try(:first) || I18n.default_locale
      I18n.locale = session[:locale] || I18n.default_locale
      session[:locale] = I18n.locale
      session[:currency] = ENV['STRIPE_CURRENCY'].upcase unless session[:currency].present?
    end

    def load_cart
      begin
        @cart = Cart.find(session[:cart_id])
      rescue ActiveRecord::RecordNotFound
        if current_user
          @cart = Cart.create(user_id: current_user.id)
        else
          @cart = Cart.create
        end
        session[:cart_id] = @cart.id
      end
    end

    def not_authenticated
  	  redirect_to login_url, alert: "#{t 'sessions.sign_in', default: 'Please sign in'}"
  	end

  	def current_cart
      @cart || Cart.new
    end

end