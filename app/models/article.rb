class Article < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug, use: [:slugged, :history]

  belongs_to :author, class_name: "User", foreign_key: "author_id"
  has_and_belongs_to_many :tags

  has_one :meta_tag, as: :meta_taggable, dependent: :destroy
  accepts_nested_attributes_for :meta_tag

  scope :public, where(public: true)
  scope :private, where(public: false)

  validates_presence_of :title, :slug, :author_id, :content, :public
  validates_uniqueness_of :title, :slug

  attr_accessible :content, :public, :slug, :title, :author_id, :tag_tokens, :meta_tag_attributes
  attr_reader :tag_tokens

 def tag_tokens=(tokens)
  self.tag_ids = Tag.ids_from_tokens(tokens)
 end

end