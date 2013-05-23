class ResellerMailer < ActionMailer::Base
  default from: ENV['DEFAULT_EMAIL_SENDER']
  layout "email"

  def reseller_request_approved(user)
  	@user = user
  	mail(to: user.email, subject: "#{I18n.t 'email.reseller_request_approved.subject'}")
  end
end