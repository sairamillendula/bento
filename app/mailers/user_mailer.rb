class UserMailer < ActionMailer::Base
  default from: "#{I18n.t 'default_email_sender'}"
  layout "email"

  def reset_password_email(user)
    @user = user
    mail(to: user.email, subject: "#{I18n.t 'email.reset_password_email.subject'}")
  end

  def welcome(user)
  	@user = user
  	mail(to: user.email, subject: "#{I18n.t 'email.welcome.subject'}")
  end
end