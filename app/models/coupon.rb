class Coupon < ActiveRecord::Base
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
end