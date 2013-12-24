class Coupon < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  
  # ASSOCIATIONS
  # ------------------------------------------------------------------------------------------------------
	has_many :orders, foreign_key: "coupon_code", primary_key: :code


  # SCOPES
  # ------------------------------------------------------------------------------------------------------
	scope :active, -> { where(active: true) }


  # VALIDATIONS
  # ------------------------------------------------------------------------------------------------------
  validates_presence_of :code, :amount
  validates_uniqueness_of :code
  

  # INSTANCE METHODS
  # ------------------------------------------------------------------------------------------------------
  def fixed?
  	percentage = false
  end

  def can_be_deleted?
  	orders.empty?
  end

  def to_s
    percentage? ? number_to_percentage(amount, strip_insignificant_zeros: true) : number_to_currency(amount, strip_insignificant_zeros: true)
  end
  
end