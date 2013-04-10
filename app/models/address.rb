# encoding: utf-8
class Address < ActiveRecord::Base
  # ASSOCIATIONS
  belongs_to :addressable, :polymorphic => true
  
  # ATTRIBUTES
  attr_accessor :bypass_validation
  attr_accessible :address1, :address2, :addressable_id, :addressable_type, :city, :country, :postal_code, :province, :type, 
                  :bypass_validation
  
  PROVINCE = [ 'Alberta', 'British Columbia', 'Manitoba', 'New Brunswick', 'Newfoundland and Labrador', 'Northwest Territories', 'Nova Scotia', 'Nunavut', 'Prince Edward Island', 'Québec', 'Ontario', 'Saskatchewan', 'Yukon', 'Alabama', 'Alaska',
              'Arizona', 'Arkansas', 'California', 'Colorado', 'Connecticut', 'Delaware', 'District of Columbia', 'Florida', 'Georgia', 
              'Hawaii', 'Idaho', 'Illinois', 'Indiana', 'Iowa','Kansas', 'Kentucky', 'Louisiana', 'Maine', 'Maryland', 'Massachusetts',
              'Michigan', 'Minnesota', 'Mississippi', 'Missouri', 'Montana', 'Nebraska', 'Nevada','New Hampshire', 'New Jersey', 'New Mexico',
              'New York', 'North Carolina', 'North Dakota', 'Ohio','Oklahoma', 'Oregon', 'Pennsylvania', 'Rhode Island', 'South Carolina',
              'South Dakota', 'Tennessee', 'Texas', 'Utah', 'Vermont', 'Virginia', 'Washington', 'West Virginia', 'Wisconsin', 'Wyoming' ]
  
  COUNTRY = ['Canada', 'USA']
  
  def all_blank?
    attributes.except("addressable_type").values.compact.reject{|s| s.blank?}.empty?
  end

  def display_name
    html = []
    html << address1 if address1.present?
    html << address2 if address2.present?
    r3 = []
    if country == 'France'
      r3 << postal_code if postal_code.present?
      r3 << city if city.present?
      html << r3.join(' ')
    else
      r3 << city if city.present?
      r3 << province if province.present?
      r3 << postal_code if postal_code.present?
      html << r3.join(', ')
    end
    html << country if country.present?
    html.join("<br/>").titleize.html_safe
  end

  def render_map
    html = []
    html << address1 if address1.present?
    r3 = []
    if country == 'France'
      r3 << postal_code if postal_code.present?
      r3 << city if city.present?
      html << r3.join(' ')
    else
      r3 << city if city.present?
      r3 << province if province.present?
      r3 << postal_code if postal_code.present?
      html << r3.join(', ')
    end
    html << country if country.present?
    html.join(", ").html_safe
  end

end