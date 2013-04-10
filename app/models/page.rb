class Page < ActiveRecord::Base
	extend FriendlyId
  friendly_id :slug, use: [:slugged, :history]

  attr_accessible :content, :name, :slug, :public, :klass

  scope :public, where(public: true)
  scope :private, where(public: false)

  validates_presence_of :name, :slug, :klass
  validates_uniqueness_of :name, :slug

  KLASS = ['standard', 'faq', 'cgv']

end