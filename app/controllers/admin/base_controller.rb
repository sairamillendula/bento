class Admin::BaseController < ApplicationController
  layout 'admin'
  before_filter :verify_admin
  before_filter { @checkout_script = true }

  private

    def verify_admin
  	  I18n.locale = 'en' # for now admin is english only
      redirect_to login_url unless current_user && current_user.admin?
    end

end