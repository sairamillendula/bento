class Tax < ActiveRecord::Base
  belongs_to :shipping_country
  has_many :region_taxes, dependent: :destroy
  accepts_nested_attributes_for :region_taxes

  attr_accessible :name, :rate, :region_taxes_attributes

  validates_numericality_of :rate, greater_than_or_equal_to: 0
end