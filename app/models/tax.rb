class Tax < ActiveRecord::Base
  
  # ASSOCIATIONS
	# ------------------------------------------------------------------------------------------------------
  belongs_to :shipping_country
  has_many :region_taxes, order: 'province', dependent: :destroy
  accepts_nested_attributes_for :region_taxes


  # VALIDATIONS
  # ------------------------------------------------------------------------------------------------------
  validates_numericality_of :rate, greater_than_or_equal_to: 0

end