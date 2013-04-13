class Page < ActiveRecord::Base
	extend FriendlyId
  friendly_id :slug, use: [:slugged, :history]

  has_one :meta_tag, as: :meta_taggable, dependent: :destroy
  accepts_nested_attributes_for :meta_tag

  attr_accessible :content, :name, :slug, :public, :klass, :meta_tag_attributes

  scope :public, where(public: true)
  scope :private, where(public: false)

  validates_presence_of :name, :slug, :klass
  validates_uniqueness_of :name, :slug

  KLASS = ['standard', 'faq', 'cgv', 'contact']

end