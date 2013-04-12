class Coupon < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper

	has_many :orders

	scope :active, where(active: true)
  #scope :nb_orders, where("orders.coupon_code = ?", :code)

  attr_accessible :active, :code, :percentage, :amount

  validates_presence_of :code, :amount
  validates_uniqueness_of :code

  def fixed?
  	percentage = false
  end

  def can_be_deleted?
  	orders.empty?
  end

  def nb_orders
    #Order.find_all_by_coupon_code("#{code}").count
  end

  def to_s
    percentage? ? number_to_percentage(amount, strip_insignificant_zeros: true) : number_to_currency(amount, strip_insignificant_zeros: true)
  end
end