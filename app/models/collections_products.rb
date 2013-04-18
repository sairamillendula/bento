class CollectionsProducts < ActiveRecord::Base
	belongs_to :collection
	belongs_to :product
	
  attr_accessible :collection_id, :position, :product_id
end