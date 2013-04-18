class Collection < ActiveRecord::Base
	extend FriendlyId
  friendly_id :slug, use: [:slugged, :history]
  
  has_and_belongs_to_many :products
  
  store :meta_tag, accessors: [:seo_title, :seo_description]

  scope :visibles, where(visible: true)
  scope :private, where(visible: false)

  attr_accessible :description, :name, :visible, :slug, :seo_title, :seo_description
  validates_presence_of :name, :slug
  validates_uniqueness_of :name

end