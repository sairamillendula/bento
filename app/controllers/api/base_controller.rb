class Api::BaseController < ApplicationController
  #include ActionController::HttpAuthentication::Token::ControllerMethods
  before_filter :restrict_access

  private

  def restrict_access
    if request.method != "OPTIONS"
      authenticate_or_request_with_http_token do |token, options|
        api_key = ENV['AUTH_TOKEN']
        token == api_key if api_key
      end
    end
  end

  # Return the CORS access control headers for all responses.
  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization, X-CSRF-Token'
  end
end