class Coupon < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper

	has_many :orders, foreign_key: "coupon_code", primary_key: :code

	scope :active, where(active: true)

  attr_accessible :active, :code, :percentage, :amount

  validates_presence_of :code, :amount
  validates_uniqueness_of :code

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