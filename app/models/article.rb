class Article < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug, use: [:slugged, :history]

  belongs_to :author, class_name: "User", foreign_key: "author_id"
  has_and_belongs_to_many :tags

  scope :public, where(public: true)
  scope :private, where(public: false)

  validates_presence_of :title, :slug, :author_id, :content
  validates_uniqueness_of :title, :slug

  attr_accessible :content, :public, :slug, :title, :author_id, :tag_tokens
  attr_reader :tag_tokens

 def tag_tokens=(tokens)
  self.tag_ids = Tag.ids_from_tokens(tokens)
 end

end