class AdminMailer < ActionMailer::Base
  default from: "#{I18n.t 'default_email_sender'}"
  default to: "admin@email.com"
  
  def new_admin_user(user, random_password)
  	@user = user
  	@random_password = random_password
  	mail(to: @user.email, subject: "#{I18n.t 'email.new_admin_user.subject'}")
  end

  def new_reseller_request(user)
  	@user = user
  	mail(subject: "#{I18n.t 'email.new_reseller_request.subject'}")
  end
end