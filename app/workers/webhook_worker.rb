class WebhookWorker
  include Sidekiq::Worker
  sidekiq_options retry: 5

  def perform(order_id)
    order = Order.find(order_id)
    webhook = Setting.first.webhook_url

    if order.present? && webhook.present?
      uri = URI.parse(webhook)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.scheme == 'https'

      body ={
        order: {
          order_id: order.id.to_s,
          code: order.code
          }
        }.to_json

        request = Net::HTTP::Post.new(uri.path, {'Content-Type' =>'application/json'})
        request.body = body
        response = http.request(request)
        response.code == '200' ? true : false
    end
  end
end