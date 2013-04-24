class ShippingCountry < ActiveRecord::Base

  has_many :rates, class_name: "ShippingRate", dependent: :destroy
  accepts_nested_attributes_for :rates, allow_destroy: true

  attr_accessible :country, :rates_attributes

  validates :country, presence: true, uniqueness: true

  after_create :create_default_shipping_rate

  def name
    Country[country].name
  end

private

  def create_default_shipping_rate
    rates.create!(name: 'International Shipping', criteria: 'weight-based', min_criteria: 0, max_criteria: 100, price: 25.0)
  end
end