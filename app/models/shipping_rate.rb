class ShippingRate < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper

  belongs_to :shipping_country
  attr_accessible :criteria, :max_criteria, :min_criteria, :name, :price

  validates_presence_of :shipping_country, :criteria, :name, :price
  validates_numericality_of :price, { greater_than_or_equal_to: 0 }
  validates_numericality_of :min_criteria, { greater_than_or_equal_to: 0 }
  validates :max_criteria, presence: true, numericality: { greater_than_or_equal_to: 0 }, if: Proc.new{|r| r.criteria == 'weight-based' }
  validate :validate_criteria

  def validate_criteria
    errors.add :max_criteria, "invalid range value" if max_criteria.present? && ((try(:max_criteria) || 0) < (try(:min_criteria) || 0))
  end

  def rate
    if criteria == 'price-based'
      if max_criteria.present?
        "#{number_to_currency(min_criteria)} - #{number_to_currency(max_criteria)}"
      else
        "#{number_to_currency(min_criteria)} and up"
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
  
end
