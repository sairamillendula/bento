class ProductRelationship < ActiveRecord::Base
  belongs_to :product
  belongs_to :other_product, class_name: "Product"
end
