class Order < ActiveRecord::Base
  ## MACHINE STATES
  module State
    PENDING   = 'pending'
    OPEN      = 'open'
    SHIPPED   = 'shipped'
    CANCELLED = 'cancelled'
    
    def self.options
      [[I18n.t(PENDING), PENDING], [I18n.t(OPEN), OPEN], [I18n.t(SHIPPED), SHIPPED], [I18n.t(CANCELLED), CANCELLED]]
    end
  end
  
  ## ASSOCIATIONS
  belongs_to :client, :class_name => "User"
  accepts_nested_attributes_for :client

  has_many :items, class_name: "LineItem", dependent: :destroy

  has_one :billing_address, :as => :addressable, :class_name => "BillingAddress", :dependent => :destroy
  accepts_nested_attributes_for :billing_address

  has_one :shipping_address, :as => :addressable, :class_name => "ShippingAddress", :dependent => :destroy
  accepts_nested_attributes_for :shipping_address

  belongs_to :coupon, :foreign_key => "coupon_code"
  has_many :audits, :class_name => "AuditTrail", as: :auditable

  ## SCOPES
  scope :opens, where(state: State::OPEN)
  
  ## ATTRIBUTES
  attr_accessible :stripe_card_token, :state, :shipped_at
  
  ## CALLBACKS
  before_create :generate_code
  after_create :update_stocks
  
  ## INSTANCE METHODS
  def to_param
    code
  end

  [State::PENDING, State::OPEN, State::SHIPPED, State::CANCELLED].each do |method|
    define_method "#{method.downcase}?" do
       self.state == method
    end
  end

  def ship(user)
    if open?
      self.update_attributes(state: State::SHIPPED, shipped_at: Time.now)
      audits.create!(message: State::SHIPPED, user_id: user.id)
    end
  end

  def cancel(user)
    if open?
      self.update_attributes(state: State::CANCELLED)
      audits.create!(message: State::CANCELLED, user_id: user.id)
    end
  end

  def build_from_cart(cart, shipping_country, shipping_estimate)
    # shipping
    self.shipping_method = shipping_estimate.try(:name)
    self.shipping_price = shipping_estimate.try(:price)
    cart.shipping = shipping_price

    # tax
    if shipping_country && shipping_country.tax
      cart.tax_name = shipping_country.tax.name
      cart.tax_rate = shipping_country.tax.rate
      if cart.shipping_address.province.present? && shipping_country.tax.region_taxes_count > 0
        province_tax = shipping_country.tax.region_taxes.find_by_province(cart.shipping_address.province)
        if province_tax && province_tax.rate.present? && province_tax.rate > 0
          cart.tax_name = province_tax.name
          cart.tax_rate = province_tax.rate
        end
      end
    else
      cart.tax_name = nil
      cart.tax_rate = nil
      cart.shipping = nil
    end

    # calculate cart
    cart.calculate
  end

  # copy everything from cart
  def copy_from_cart(cart)
    # items
  	cart.items.each do |item|
      #item.product.in_stock = item.product.in_stock - item.quantity || 0
      item.cart_id = nil
      item.price = item.current_price
      items << item
    end

    # addresses
    build_billing_address.copy(cart.billing_address)
    build_shipping_address.copy(cart.shipping_address)

    # values
    self.subtotal = cart.subtotal
    self.tax_name = cart.tax_name
    self.tax_rate = cart.tax_rate
    self.total = cart.total
    self.coupon_code = cart.coupon_code
    self.coupon_amount = cart.coupon_amount
    self.coupon_percentage = cart.coupon_percentage
  end

  def subtotal
    @subtotal ||= items.inject(0) { |sum, item| sum + item.subtotal }.round(2)
  end

  # process payment and save
  def save_with_payment(cart)
    Stripe.api_key = ENV['STRIPE_API_KEY']
    charge = Stripe::Charge.create(
      card: stripe_card_token,
      amount: (total * 100).to_i,
      currency: "cad",
      description: "#{cart.email}"
      # application_fee: amount * ENV['STRIPE_APPLICATION_FEE'] / 100
    )

    self.stripe_card_token = charge.id
    self.currency = "cad"
    self.card_type = charge.card.type
    self.last4 = charge.card.last4
    self.state = State::OPEN
    save!
    self.audits.create(message: State::OPEN)

    # after order created, create user if guest
    if client_id.blank?
      random_password = SecureRandom.hex(4)
      u = User.new(email: cart.email, first_name: cart.first_name, last_name: cart.last_name, password: random_password, password_confirmation: random_password)
      if u.save
        self.client = u
        update_attribute(:client_id, u.id)
        UserMailer.welcome(u).deliver
      end
    end

    # save order addresses to user address
    unless client.addresses.select {|address| address.same_as(billing_address) }.size > 0
      client.addresses.build.copy(billing_address).save!
    end
    unless client.addresses.select {|address| address.same_as(shipping_address) }.size > 0
      client.addresses.build.copy(shipping_address).save!
    end

    return true

  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    false
  end

  def coupon_formatted
    if coupon_code.present?
      coupon_percentage.present? ? subtotal*coupon_amount/100 : coupon_amount
    end  
  end

private

  def generate_code
    last_order_id = Order.last.present? ? Order.last.id : 0
    self.code = "%05d" % (last_order_id + 1)
  end

  def update_stocks
    items.each do |item|
      buyable = item.buyable
      buyable.in_stock -= item.quantity
      buyable.orders_count += 1
      buyable.save
    end
    if coupon
      coupon.orders_count += 1
      coupon.save
    end
  end

end
