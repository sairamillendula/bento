class UserMailer < ActionMailer::Base
  default from: ENV['DEFAULT_EMAIL_SENDER']
  layout "email_theme"

  def reset_password_email(user)
    @user = user
    mail(to: user.email, subject: "#{I18n.t 'email.reset_password_email.subject'}")
  end

  def welcome(user)
  	@user = user
  	mail(to: user.email, subject: "#{I18n.t 'email.welcome.subject'}")
  end
end