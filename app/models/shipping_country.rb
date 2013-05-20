class ShippingCountry < ActiveRecord::Base

  has_many :rates, class_name: "ShippingRate", dependent: :destroy
  accepts_nested_attributes_for :rates, allow_destroy: true

  has_one :tax, dependent: :destroy

  attr_accessible :country, :rates_attributes

  validates :country, presence: true, uniqueness: true

  after_create :create_default_shipping_rate

  def name
    Country[country].name
  end

private

  def create_default_shipping_rate
    rates.create!(name: 'International Shipping', criteria: 'price-based', min_criteria: 0, price: 25.0)

    country_tax = create_tax!

    if Country[country].subdivisions?
      Country[country].subdivisions.keys.each do |region|
        country_tax.region_taxes.create!(province: region)
      end
    end
  end
end