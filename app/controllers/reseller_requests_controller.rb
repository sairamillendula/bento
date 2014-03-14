class ResellerRequestsController < ApplicationController
  before_filter :require_login, only: :create

  def new
  	@reseller_request = ResellerRequest.new
  end

	def create
		@reseller_request = ResellerRequest.new(safe_params)
    @reseller_request.user_id = current_user.id if current_user

    respond_to do |format|
      if @reseller_request.save(safe_params)
        format.html { redirect_to become_reseller_url, notice: "#{t 'resellers.become_reseller_success'}." }
        AdminMailer.new_reseller_request(@reseller_request.user).deliver
      else
        format.html { redirect_to become_reseller_url, alert: "#{t 'resellers.become_reseller_error'}." }
      end
    end
	end

  private

    def safe_params
      params.require(:reseller_request).permit(:country, :business_name, :city, :who_are_you, :user_id)
    end

end