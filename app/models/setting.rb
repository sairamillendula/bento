class Setting < ActiveRecord::Base

  # ATTRIBUTES
  # ------------------------------------------------------------------------------------------------------
  store_accessor :options, :logo_id, :abandoned_carts_reminder, :webhook_url


  # VALIDATIONS
  # ------------------------------------------------------------------------------------------------------
  validate :webhook


  # INSTANCE METHODS
  # ------------------------------------------------------------------------------------------------------
  def self.logo
    Picture.find(Setting.first.logo_id) rescue nil
  end

  def webhook
    unless webhook_url.blank?
      uri = URI.parse(webhook_url)
      port = uri.port == 80 ? nil : uri.port
      if uri.scheme.nil?
        uri.scheme = 'http'
        self.webhook_url = URI::Generic::new uri.scheme, nil, webhook_url, nil, nil, nil, nil, nil, nil
      elsif uri.scheme == 'http'
        self.webhook_url = URI::Generic::new uri.scheme, nil, uri.host, port, nil, uri.path, nil, nil, nil
      elsif uri.scheme == 'https'
        self.webhook_url = URI::Generic::new uri.scheme, nil, uri.host, port, nil, uri.path, nil, nil, nil
      else
        raise URI::InvalidURIError
      end
    end
  rescue URI::InvalidURIError
    errors.add(:base, "Invalid webhook url scheme")
  end
end
