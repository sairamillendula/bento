class StripeController < ApplicationController

	def connect
	  #puts request.env['omniauth.auth'].to_yaml
	  code = params[:code]
	  redirect_to "https://connect.stripe.com/oauth/token?client_secret=#{ENV['STRIPE_API_KEY']}&code=#{code}&grant_type=authorization_code",
	              method: :post
	end

end