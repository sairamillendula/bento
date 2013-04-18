class Page < ActiveRecord::Base
	extend FriendlyId
  friendly_id :slug, use: [:slugged, :history]

  store :meta_tag, accessors: [:seo_title, :seo_description]

  attr_accessible :content, :name, :slug, :visible, :klass, :meta_tag, :seo_title, :seo_description

  scope :visibles, where(visible: true)
  scope :private, where(visible: false)

  validates_presence_of :name, :slug
  validates_uniqueness_of :name, :slug

  KLASS = ['standard', 'faq', 'cgv', 'contact']

end