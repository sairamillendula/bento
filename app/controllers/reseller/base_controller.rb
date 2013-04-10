class Reseller::BaseController < ApplicationController
  #layout 'admin'
  before_filter :verify_reseller

private
    
  def verify_reseller
    redirect_to root_url unless current_user && current_user.reseller?
  end
end