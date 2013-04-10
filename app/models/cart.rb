class Cart < ActiveRecord::Base
  has_many :items, class_name: "LineItem", dependent: :destroy
  accepts_nested_attributes_for :items, allow_destroy: true

  attr_accessible :items_attributes
  
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

  def calculate
    self.subtotal = items.inject(0) { |sum, item| sum + item.subtotal }
    self.total = subtotal
    self.save
  end
end