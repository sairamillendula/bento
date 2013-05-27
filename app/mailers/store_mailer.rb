class StoreMailer < ActionMailer::Base
	default from: ENV['DEFAULT_EMAIL_SENDER']
  layout "email_theme"

  def order_receipt(order)
  	@order = order
  	mail(to: order.client.email, subject: "#{I18n.t 'email.order_receipt.subject'}")
  end
end