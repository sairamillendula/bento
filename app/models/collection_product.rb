class CollectionProduct < ActiveRecord::Base
	belongs_to :collection
	belongs_to :product

  acts_as_list scope: :collection
end