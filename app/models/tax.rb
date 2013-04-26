class Tax < ActiveRecord::Base
  belongs_to :shipping_country
  has_many :region_taxes, dependent: :destroy
  accepts_nested_attributes_for :region_taxes

  attr_accessible :rate, :region_taxes_attributes
end
