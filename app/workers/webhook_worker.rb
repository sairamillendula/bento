class WebhookWorker
  include Sidekiq::Worker
  sidekiq_options retry: 5

  # WebhookWorker.perform_async(order_id)
  def perform(order_id)
    order = Order.find(order_id)
    settings = Setting.first
    webhook = settings.webhook_url
    token = ENV['AUTH_TOKEN']

    StoreMailer.order_receipt(order).deliver
    AdminMailer.new_order(order).deliver

    if order.present? && webhook.present?
      uri = URI.parse(webhook)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.scheme == 'https'
      headers = {
        "User-Agent" => 'Webhook',
        'Content-Type' =>'application/json',
        "Authorization" => "Token token=\"#{token}\""
      }
      body = {
        order: {
          order_id: order.id.to_s,
          uid: order.code,
          currency: order.currency,
          date: order.created_at,
          amount: order.subtotal,
          shipping: order.shipping_price,
          total_price: order.total,
          if order.coupon_code.present?
            coupon: true,
            coupon_code: order.coupon_code
          end
          country: order.billing_address.country,
          city: order.billing_address.city,
          url: order_url(order.id).to_s,
          client_email: order.client.email,
          products_count: order.total_products
        }
      }.to_json

      request = Net::HTTP::Post.new(uri.path, headers)
      request.body = body
      response = http.request(request)
      response.code == '200' ? true : false
    end
  end
end
