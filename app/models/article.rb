class Article < ActiveRecord::Base

  # FRIENDLY ID
  # ------------------------------------------------------------------------------------------------------
  extend FriendlyId
  friendly_id :slug, use: [:slugged, :history]
  include Sluggable


  # ATTRIBUTES
  # ------------------------------------------------------------------------------------------------------
  attr_reader :tag_tokens
  store :meta_tag, accessors: [:seo_title, :seo_description]

  
  # ASSOCIATIONS
  # ------------------------------------------------------------------------------------------------------
  belongs_to :author, class_name: "User", foreign_key: "author_id"
  has_and_belongs_to_many :tags

  
  # SCOPES
  # ------------------------------------------------------------------------------------------------------
  scope :visibles, -> { where(visible: true) }
  scope :private, -> { where(visible: false) }
  

  # VALIDATIONS
  # ------------------------------------------------------------------------------------------------------
  validates_presence_of :title, :slug, :author_id, :content
  validates_uniqueness_of :title, :slug
  

  # INSTANCE METHODS
  # ------------------------------------------------------------------------------------------------------
  def tag_tokens=(tokens)
    self.tag_ids = Tag.ids_from_tokens(tokens)
  end

end
