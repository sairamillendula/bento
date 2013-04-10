class StoreMailer < ActionMailer::Base
  default from: "#{I18n.t 'default_email_sender'}"
  layout "email"

  def purchase_receipt(order)
  	@order = order
  	mail(to: order.client.email, subject: "#{I18n.t 'email.purchase_receipt.subject'}")
  end
end