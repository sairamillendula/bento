class Api::BaseController < ApplicationController
  skip_before_action :load_cart
  skip_before_action :set_locale

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