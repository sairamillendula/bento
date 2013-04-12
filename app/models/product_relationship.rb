class ProductRelationship < ActiveRecord::Base
  belongs_to :product
  belongs_to :other_product, class_name: "Product"
  
  attr_accessible :product_id, :other_product_id
end
