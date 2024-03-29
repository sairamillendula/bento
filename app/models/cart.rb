class Cart < ActiveRecord::Base

  # ASSOCIATIONS
  # ------------------------------------------------------------------------------------------------------
  has_many :items, class_name: "LineItem", dependent: :destroy
  accepts_nested_attributes_for :items, reject_if: proc { |a| a['quantity'].to_i == 0 }, allow_destroy: true

  has_one :billing_address, as: :addressable, class_name: "BillingAddress", dependent: :destroy
  accepts_nested_attributes_for :billing_address

  has_one :shipping_address, as: :addressable, class_name: "ShippingAddress", dependent: :destroy
  accepts_nested_attributes_for :shipping_address

  belongs_to :user


  # ATTRIBUTES
  # ------------------------------------------------------------------------------------------------------
  attr_accessor :tax_amount


  # SCOPES
  # ------------------------------------------------------------------------------------------------------
  scope :not_reminded, -> { where(reminded: false) }
  scope :with_items,   -> { where("line_items_count > ?", 0) }


  # VALIDATIONS
  # ------------------------------------------------------------------------------------------------------
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/, allow_blank: true
  validate :validate_coupon_code_exists, if: :coupon_code?

  before_validation do |cart|
    if billing_address && billing_address.also_shipping_address
      if shipping_address
        shipping_address.copy(billing_address)
        shipping_address.bypass_validation = true
      end
    end
  end


  # INSTANCE METHODS
  # ------------------------------------------------------------------------------------------------------
  # buyable can be product or variant
  # return: line item
  def add_to_cart(variant)
    if variant.in_stock?
      current_item = items.where(variant_id: variant.id).first_or_initialize
      current_item.quantity += 1 unless current_item.new_record?
      current_item.price = variant.current_price
      current_item.save
      calculate
  	  current_item
    else
      I18n.t("theme.out_of_stock", default: "Out of Stock")
    end
  end

  def remove_from_cart(line_id)
    items.where(id: line_id).destroy_all
    calculate
  end

  def apply_coupon(code)
    begin
      coupon = Coupon.active.find_by_code!(code)
      self.coupon_code = code
      self.coupon_amount = coupon.amount
      self.coupon_percentage = coupon.percentage
      calculate
    rescue Exception => e
      puts e.message
      puts e.backtrace
      # if coupon does not valid, then remove it from cart
      remove_coupon
    end
  end

  def remove_coupon
    puts "remove_coupon"
    self.coupon_code = nil
    self.coupon_amount = nil
    self.coupon_percentage = nil
    calculate
  end

  def calculate
    self.subtotal = items.inject(0) { |sum, item| sum + item.subtotal }

    # discount
    self.total = subtotal - discount

    # shipping
    self.total += try(:shipping) || 0

    # tax
    @tax_amount = subtotal * ((try(:tax_rate) || 0) / 100)
    self.total += @tax_amount

    self.save
  end

  def discount
    if coupon_applied?
      if !!coupon_percentage
        (subtotal * ((coupon_amount || 0) / 100)).truncate(2)
      else
        coupon_amount || 0
      end
    else
      0
    end
  end

  def coupon_applied?
    coupon_code && coupon_amount
  end

  def shipping_availability?
    if shipping_address && shipping_address.country
      shipping_country = ShippingCountry.find_by_country(shipping_address.country) || ShippingCountry.find_by_country('WORLDWIDE')
      shipping_country.present?
    end
  end

  def has_no_email?
    user_id.blank? && email.blank?
  end

  def mark_as_reminded
    self.reminded = true
    self.reminded_at = Time.now
    self.save!
  end

  private

    def validate_coupon_code_exists
      begin
        coupon = Coupon.active.find_by_code!(coupon_code)
        self.coupon_amount = coupon.amount
        self.coupon_percentage = coupon.percentage
      rescue
        # if coupon not valid, then remove it from cart
        self.coupon_code = nil
        self.coupon_amount = nil
        self.coupon_percentage = nil
      end
    end

end