class Stock < ActiveRecord::Base

  # ASSOCIATIONS
  # ------------------------------------------------------------------------------------------------------
	belongs_to :product
  belongs_to :product_variant
  

  # VALIDATIONS
  # ------------------------------------------------------------------------------------------------------
  validates_presence_of :product_id
  validates_uniqueness_of :product_id, scope: :product_variant_id, on: :create


  # INSTANCE METHODS
  # ------------------------------------------------------------------------------------------------------
  def in_stock?
    in_stock > 0
  end

end