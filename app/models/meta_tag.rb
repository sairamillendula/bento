class MetaTag < ActiveRecord::Base
	belongs_to :meta_taggable, polymorphic: true
end