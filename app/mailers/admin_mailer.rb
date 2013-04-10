class AdminMailer < ActionMailer::Base
  default from: "#{I18n.t 'default_email_sender'}"
  default to: "admin@email.com"

  def new_reseller_request(user)
  	@user = user
  	mail(subject: "#{I18n.t 'email.new_reseller_request.subject'}")
  end
end