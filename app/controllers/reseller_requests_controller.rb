class ResellerRequestsController < ApplicationController
  before_filter :require_login, only: :create
  
  def new
  	@reseller_request = current_user.build_reseller_request
  end

	def create
		@reseller_request = current_user.build_reseller_request(params[:reseller_request])

    respond_to do |format|
      if @reseller_request.save(params[:reseller_request])
        format.html { redirect_to become_reseller_url, notice: "#{t 'resellers.become_reseller_success'}." }
        AdminMailer.new_reseller_request(@reseller_request.user).deliver
      else
        format.html { redirect_to become_reseller_url, alert: "#{t 'resellers.become_reseller_error'}." }
      end
    end
	end

end