class Collection < ActiveRecord::Base
	
  # FRIENDLY ID
  # ------------------------------------------------------------------------------------------------------
  extend FriendlyId
  friendly_id :slug, use: [:slugged, :history]
  include Sluggable
  include PgSearch
  

  # SEARCH
  # ------------------------------------------------------------------------------------------------------
  multisearchable :against => :name
  pg_search_scope :search_by_keyword, 
                  :against => [:name],
                  :using => {
                    :tsearch => {
                      :prefix => true # match any characters
                    }
                  },
                  :ignoring => :accents
  
  
  # ASSOCIATIONS
  # ------------------------------------------------------------------------------------------------------
  has_many :collection_products, dependent: :destroy
  has_many :products, through: :collection_products

  
  # ATTRIBUTES
  # ------------------------------------------------------------------------------------------------------
  store :meta_tag, accessors: [:seo_title, :seo_description]


  # CALLBACKS
  # ------------------------------------------------------------------------------------------------------
  before_save :format_slug
  

  # SCOPES
  # ------------------------------------------------------------------------------------------------------
  scope :visibles, -> { where(visible: true) }
  scope :private, -> { where(visible: false) }


  # VALIDATIONS
  # ------------------------------------------------------------------------------------------------------
  validates_presence_of :name, :slug
  validates_uniqueness_of :name, :slug

end