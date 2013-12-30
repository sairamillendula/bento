class ShippingRate < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  
  # ASSOCIATIONS
  # ------------------------------------------------------------------------------------------------------
  belongs_to :shipping_country

  
  # VALIDATIONS
  # ------------------------------------------------------------------------------------------------------
  validates_presence_of :shipping_country, :criteria, :name, :price
  validates_numericality_of :price, { greater_than_or_equal_to: 0 }
  validates_numericality_of :min_criteria, { greater_than_or_equal_to: 0 }
  validates :max_criteria, presence: true, numericality: { greater_than_or_equal_to: 0 }, if: Proc.new{|r| r.criteria == 'weight-based' }
  validate :validate_criteria
  

  # INSTANCE METHODS
  # ------------------------------------------------------------------------------------------------------
  def validate_criteria
    errors.add :max_criteria, "invalid range value" if max_criteria.present? && ((try(:max_criteria) || 0) < (try(:min_criteria) || 0))
  end

  def rate
    if criteria == 'price-based'
      if max_criteria.present?
        "#{number_to_currency(min_criteria)} - #{number_to_currency(max_criteria)}"
      else
        "#{number_to_currency(min_criteria)} #{I18n.t 'and_up', default: 'and up'}"
      end
    else
      "#{min_criteria} kg - #{max_criteria} kg"
    end
  end

  def unit
    criteria == 'price-based' ? '$' : 'kg'
  end

  def is_free?
    price == 0
  end

  # TODO: add weight check
  def self.estimate(amount, shipping_rates, criteria='price-based')
    if shipping_rates
      applicable_rates = shipping_rates.select {|shipping_rate| shipping_rate.criteria == criteria && amount >= shipping_rate.min_criteria }
      if applicable_rates.present?
        compare = lambda {|a,b| a.price <=> b.price}
        applicable_rates.min &compare
      else
        shipping_rates.first
      end
    end
  end

  def to_s
    "#{name} - #{number_to_currency price}"
  end
  
end
