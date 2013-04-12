class Cart < ActiveRecord::Base
  has_many :items, class_name: "LineItem", dependent: :destroy
  accepts_nested_attributes_for :items, allow_destroy: true

  attr_accessible :items_attributes, :coupon_code

  validate :validate_coupon_code_exists, :if => :coupon_code?
  
  # buyable can be product or variant
  # return: line item
  def add_to_cart(buyable)
    if buyable.is_a?(Product)
	   current_item = items.where(product_id: buyable.id).first_or_initialize
    elsif buyable.is_a?(ProductVariant)
      current_item = items.where(product_variant_id: buyable.id).first_or_initialize
    else
      raise ArgumentError.new('give argument must be an instance of Product or ProductVariant')
    end
    current_item.quantity += 1 unless current_item.new_record?
    current_item.save
    calculate
	  current_item
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
    self.total = subtotal - discount
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

  private

  def validate_coupon_code_exists
    begin
      coupon = Coupon.active.find_by_code!(coupon_code)
      self.coupon_amount = coupon.amount
      self.coupon_percentage = coupon.percentage
    rescue
      # if coupon does not valid, then remove it from cart
      self.coupon_code = nil
      self.coupon_amount = nil
      self.coupon_percentage = nil
    end
  end
end