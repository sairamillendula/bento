class StoreMailer < ActionMailer::Base
	default from: "#{I18n.t 'theme.site_name'} <#{ENV['DEFAULT_EMAIL_SENDER']}>"
	default reply_to: ENV['DEFAULT_CONTACT_EMAIL']
	
  layout "email_theme"

  def order_receipt(order)
  	@order = order
  	mail(to: order.client.email, subject: "#{I18n.t 'email.order_receipt.subject'}")
  end
end