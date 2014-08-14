class ShippingCountry < ActiveRecord::Base
  
  # ASSOCIATIONS
  # ------------------------------------------------------------------------------------------------------
  has_many :rates, class_name: "ShippingRate", dependent: :destroy
  accepts_nested_attributes_for :rates, allow_destroy: true

  has_one :tax, dependent: :destroy


  # VALIDATIONS
  # ------------------------------------------------------------------------------------------------------
  validates :country, presence: true, uniqueness: true

  
  # CALLBACKS
  # ------------------------------------------------------------------------------------------------------
  after_create :create_default_shipping_rate
  

  # INSTANCE METHODS
  # ------------------------------------------------------------------------------------------------------
  def name
    Country[country].name
  end

  def self.find_by_country(name)
    where(country: name).first || where(country: Country.find_by_name(name)[0]).first rescue nil || where(country: Country.find_by_alpha2(name)[0]).first rescue nil
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