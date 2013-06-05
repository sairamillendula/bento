class ResellerMailer < ActionMailer::Base
  default from: ENV['DEFAULT_EMAIL_SENDER']
  default reply_to: ENV['DEFAULT_CONTACT_EMAIL']
  
  layout "email_theme"

  def reseller_request_approved(user)
  	@user = user
  	mail(to: user.email, subject: "#{I18n.t 'email.reseller_request_approved.subject'}")
  end
end