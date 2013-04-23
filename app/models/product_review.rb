class ProductReview < ActiveRecord::Base
  belongs_to :user
  belongs_to :product

  scope :approved, where(approved: true)

  attr_accessible :username, :message, :product_id, :rating, :user_id, :approved

  validates_presence_of :message, :rating, :username
  validates_uniqueness_of :user_id, scope: :product_id
end