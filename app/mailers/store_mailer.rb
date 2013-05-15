class StoreMailer < ActionMailer::Base
  default from: "#{I18n.t 'default_email_sender'}"
  layout "email"

  def order_receipt(order)
  	@order = order
  	mail(to: order.client.email, subject: "#{I18n.t 'email.order_receipt.subject'}")
  end
end