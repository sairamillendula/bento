class Cart < ActiveRecord::Base
  has_many :items, class_name: "LineItem", dependent: :destroy
  
  def add_product(product_id)
	  current_item = items.find_by_product_id(product_id)

	  if current_item
	    current_item.quantity += 1
	  else
	    current_item = items.build(product_id: product_id)
	  end
	  current_item
  end

  def subtotal
    @subtotal ||= items.inject(0) { |sum, item| sum + item.current_price }.round(2)
  end

  def total
  	@total = subtotal
  end
end