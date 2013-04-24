class CollectionProduct < ActiveRecord::Base
	belongs_to :collection
	belongs_to :product

  acts_as_list scope: :collection
	
  attr_accessible :collection_id, :position, :product_id
end