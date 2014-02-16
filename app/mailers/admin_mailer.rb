class AdminMailer < ActionMailer::Base
  default from: "#{I18n.t 'theme.site_name'} <#{ENV['DEFAULT_EMAIL_SENDER']}>"
  default to: ENV['DEFAULT_ADMIN_EMAIL']
  layout "email_admin"

  def new_admin_user(user, random_password)
  	@user = user
  	@random_password = random_password
  	mail(to: @user.email, subject: "#{I18n.t 'email.new_admin_user.subject'}")
  end

  def new_reseller_request(user)
  	@user = user
  	mail(subject: "#{I18n.t 'email.new_reseller_request.subject'}")
  end

  def contact_us(contact)
    @contact = contact
    mail(from: contact.email, subject: "#{I18n.t 'email.contact_us.subject'}")
  end

  def new_order(order)
    layout false
    @order = order
    mail(subject: "#{I18n.t 'email.new_order.subject'}")
  end
end