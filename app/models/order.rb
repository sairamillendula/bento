class Order < ActiveRecord::Base

  belongs_to :client, :class_name => "User", foreign_key: "user_id"
  accepts_nested_attributes_for :client

  has_many :items, class_name: "LineItem", dependent: :destroy

  has_one :billing_address, :as => :addressable, :class_name => "BillingAddress", :dependent => :destroy
  accepts_nested_attributes_for :billing_address#, :reject_if => lambda {|add| add[:address1].blank?}, :allow_destroy => true

  has_one :shipping_address, :as => :addressable, :class_name => "ShippingAddress", :dependent => :destroy
  accepts_nested_attributes_for :shipping_address

  has_one :coupon, :foreign_key => "coupon_code"
  has_many :audits, :class_name => "AuditTrail", as: :auditable
  
  # scope :completed, where(completed: true)
  # scope :shipped, where(shipped: true)

  attr_accessible :stripe_card_token
  #attr_accessor :stripe_card_token

  before_create :generate_code

  state_machine :initial => :pending do
    event :ship do
      transition :pending => :shipped
    end
    event :complete do
      transition :shipped => :completed
    end    
  end

  state_machine.states.map do |state|
    scope state.name, where(state: state.name.to_s)
  end

  def to_param
  	code
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
        if province_tax && province_tax.rate > 0
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

  def status
  	if shipped?
  		"shipped"
  	elsif completed?
  		"completed"
  	else
  		"pending"
  	end
  end

  def mark_as_shipped
    self.shipped = true
    self.shipped_at = Time.now
    save!
    audits.create! message: "Shipped"
  end

  def subtotal
    @subtotal ||= items.inject(0) { |sum, item| sum + item.subtotal }.round(2)
  end

  def total
    @total = subtotal # TODO add shipping, discount
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
    save!

  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    false
  end

private

  def generate_code
    last_order_id = Order.last.present? ? Order.last.id : 0
    self.code = "%05d" % (last_order_id + 1)
  end

end
