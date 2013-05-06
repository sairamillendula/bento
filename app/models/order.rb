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
  
  scope :completed, where(completed: true)
  scope :shipped, where(shipped: true)

  attr_accessible :user_id, :subtotal, :tax, :shipping, :total, :coupon_code, :client_attributes, :shipping_address, :billing_address, 
                  :shipped, :shipped_at, :shipping_address_attributes, :billing_address_attributes, :stripe_card_token
  #attr_accessor :stripe_card_token

  before_create :generate_code

  def to_param
  	code
  end

  def add_items_from_cart(cart)
  	cart.items.each do |item|
      #item.product.in_stock = item.product.in_stock - item.quantity || 0
      item.cart_id = nil
      item.price = item.current_price
      items << item
    end
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

  def save_with_payment(total)
    if valid?
      charge = Stripe::Charge.create(
        card: stripe_card_token,
        amount: (total * 100).to_i,
        currency: "cad",
        description: "#{client.email}",
        application_fee: amount * ENV['STRIPE_APPLICATION_FEE'] / 100
      )

      self.total = total
      self.stripe_card_token = charge.id
      self.currency = "cad"
      self.card_type = charge.card.type
      self.last4 = charge.card.last4
      save!
    end

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
