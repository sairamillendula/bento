class WebhookWorker
  include Sidekiq::Worker
  sidekiq_options retry: 5

  def perform(order_id)
    order = Order.find(order_id)
    settings = Setting.first
    webhook = settings.webhook_url
    token = ENV['AUTH_TOKEN']

    if order.present? && webhook.present?
      uri = URI.parse(webhook)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.scheme == 'https'
     headers = {
        "User-Agent" => 'Webhook',
        'Content-Type' =>'application/json',
        "Authorization" => "Token token=\"#{token}\""
      }
      body ={
        order: {
          order_id: order.id.to_s,
          code: order.code
          }
        }.to_json

        request = Net::HTTP::Post.new(uri.path, headers)
        request.body = body
        response = http.request(request)
        response.code == '200' ? true : false
    end
  end
end