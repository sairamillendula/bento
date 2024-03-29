class WebhookWorker
  include Sidekiq::Worker
  sidekiq_options queue: :bento, retry: 5

  # WebhookWorker.perform_async(order_id)
  def perform(order_id)
    order = Order.find(order_id)
    settings = Setting.first
    webhook = settings.webhook_url
    token = ENV['AUTH_TOKEN']
    coupon, coupon_code = false, nil

    if order.present? && webhook.present?
      uri = URI.parse(webhook)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.scheme == 'https' || uri.port == 443
      headers = {
        "User-Agent" => 'Webhook',
        'Content-Type' =>'application/json',
        "Authorization" => "Token token=\"#{token}\""
      }
      if order.coupon_code.present?
        coupon = true
        coupon_code = order.coupon_code
      end
      body = {
        order: {
          uid: order.code,
          currency: order.currency,
          date: order.created_at,
          amount: order.subtotal,
          shipping: order.shipping_price,
          tax: (order.subtotal * (order.tax_rate / 100)).to_s,
          total_price: order.total,
          coupon: coupon,
          coupon_code: coupon_code,
          country: ShippingCountry.find_by(country: order.billing_address.country).name,
          city: order.billing_address.city,
          url: Rails.application.routes.url_helpers.admin_order_url(host: ENV['HOST'], id: order.id),
          client_email: order.client.email,
          products_count: order.total_products,
          source: 'website'
        }
      }.to_json

      request = Net::HTTP::Post.new(uri.path, headers)
      request.body = body
      begin
        response = http.request(request)
        response.code == '200' ? true : false
      rescue
        false
        puts "**** #{response.message} ****"
      end
    end
  end
end
