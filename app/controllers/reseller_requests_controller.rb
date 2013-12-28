class ResellerRequestsController < ApplicationController
  before_filter :require_login, only: :create
  
  def new
  	@reseller_request = current_user.build_reseller_request
  end

	def create
		@reseller_request = current_user.build_reseller_request(safe_params, as: :manager)

    respond_to do |format|
      if @reseller_request.save(safe_params, as: :manager)
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

      params.require(:reseller_request).permit(:country, :business_name, :city, :who_are_you, :user_id, :approved, as: :manager)
    end

end