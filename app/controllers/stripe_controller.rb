class StripeController < ApplicationController

	def callback
	  puts request.env['omniauth.auth'].to_yaml
    render :nothing => true
	end

end