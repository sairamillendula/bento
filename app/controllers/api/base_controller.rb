class Api::BaseController < ApplicationController
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

end