class LineItem < ActiveRecord::Base
	belongs_to :buyable, polymorphic: true
  belongs_to :cart
  belongs_to :order, counter_cache: true
  
  attr_accessible :cart_id, :buyable_id, :buyable_type, :quantity, :price, :order_id

  before_save :ensure_valid_quantity

  def subtotal
  	quantity * current_price
  end

  def current_price
  	buyable.price
  end

  def is_variant?
    buyable_type == 'ProductVariant'
  end

private

  def ensure_valid_quantity
    self.quantity = 0 if quantity < 0
  end
end