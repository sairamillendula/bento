class Page < ActiveRecord::Base
	
  # FIRENDLY ID
  # ------------------------------------------------------------------------------------------------------
  extend FriendlyId
  friendly_id :slug, use: [:slugged, :history]
  include Sluggable
  

  # ATTRIBUTES
  # ------------------------------------------------------------------------------------------------------
  store :meta_tag, accessors: [:seo_title, :seo_description]


  # SCOPES
  # ------------------------------------------------------------------------------------------------------
  scope :visibles, -> { where(visible: true) }
  scope :private, -> { where(visible: false) }


  # VALIDATIONS
  # ------------------------------------------------------------------------------------------------------
  validates_presence_of :name, :slug
  validates_uniqueness_of :name, :slug
  

  # CONSTANTS
  # ------------------------------------------------------------------------------------------------------
  KLASS = ['standard', 'faq', 'cgv', 'contact']

end