class ProductReview < ActiveRecord::Base

	# ASSOCIATIONS
  # ------------------------------------------------------------------------------------------------------
  belongs_to :user
  belongs_to :product
  

  # SCOPES
  # ------------------------------------------------------------------------------------------------------
  scope :approved, -> { where(approved: true) }
  

  # VALIDATIONS
  # ------------------------------------------------------------------------------------------------------
  validates_presence_of :message, :rating, :username
  validates_uniqueness_of :user_id, scope: :product_id


  # INSTANCE METHODS
  # ------------------------------------------------------------------------------------------------------
  def toggle_product_review_status
    self.approved = !approved
    save!
  end

end