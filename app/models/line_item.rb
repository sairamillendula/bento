class LineItem < ActiveRecord::Base
	belongs_to :product
  belongs_to :variant, class_name: "ProductVariant", foreign_key: 'product_variant_id'
  belongs_to :cart
  belongs_to :order
  
  attr_accessible :cart_id, :product_id, :product_variant_id, :quantity, :price, :order_id

  def subtotal
  	quantity * price
  end

  def current_price
  	product_variant_id.present? ? variant.current_price : product.current_price
  end
end