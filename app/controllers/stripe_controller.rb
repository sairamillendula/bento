require "net/http"
require "uri"

class StripeController < ApplicationController

  def callback
    uri = URI.parse('https://connect.stripe.com/oauth/token')
    https = Net::HTTP.new(uri.host,uri.port)
    https.use_ssl = true
    req = Net::HTTP::Post.new(uri.path)
    req.body = {"client_secret" => ENV['STRIPE_API_KEY'], 'code' => params["code"], "grant_type" => "authorization_code"}.to_query
    res = https.request(req)
    response = YAML.load(res.body)
    Setting.stripe_access_token = response['access_token']

    redirect_to admin_dashboard_path, notice: "#{t 'stripe.account_connected'}."
  end

end