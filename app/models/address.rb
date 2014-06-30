# encoding: utf-8
class Address < ActiveRecord::Base

  # ASSOCIATIONS
  # ------------------------------------------------------------------------------------------------------
  belongs_to :addressable, polymorphic: true


  # ATTRIBUTES
  # ------------------------------------------------------------------------------------------------------
  attr_accessor :bypass_validation


  # INSTANCE METHODS
  # ------------------------------------------------------------------------------------------------------
  def all_blank?
    attributes.except("addressable_type").values.compact.reject{|s| s.blank?}.empty?
  end

  def display_name(sep="<br/>")
    html = []
    html << address1 if address1.present?
    html << address2 if address2.present?
    r3 = []
    if country == 'FR' || country =='France'
      r3 << postal_code if postal_code.present?
      r3 << city if city.present?
      html << r3.join(' ')
    else
      r3 << city if city.present?
      r3 << country_obj.subdivisions[province]['name'] if country_obj.present? && country_obj.subdivisions[province].present?
      r3 << postal_code if postal_code.present?
      html << r3.join(', ')
    end
    html << country_obj.name if country_obj.present?
    html.join(sep).titleize.html_safe
  end

  def for_display
    html = []
    html << address1 if address1.present?
    r3 = []
    r3 << city if city.present?
    r3 << province if province.present?
    r3 << postal_code if postal_code.present?
    html << r3.join(', ')
    html << country_obj.name if country_obj.present?
    html.join("\n").html_safe
  end

  def render_map
    html = []
    html << address1 if address1.present?
    r3 = []
    if country == 'FR' || country =='France'
      r3 << postal_code if postal_code.present?
      r3 << city if city.present?
      html << r3.join(' ')
    else
      r3 << city if city.present?
      r3 << province if province.present?
      r3 << postal_code if postal_code.present?
      html << r3.join(', ')
    end
    html << country_obj.name if country_obj.present?
    html.join(", ").html_safe
  end

  def bypass_validation
    ActiveRecord::ConnectionAdapters::Column.value_to_boolean(@bypass_validation)
  end

  def copy(address)
    if address
      self.full_name = address.full_name
      self.address1 = address.address1
      self.address2 = address.address2
      self.city = address.city
      self.country = address.country
      self.postal_code = address.postal_code
      self.province = address.province
    end
    self
  end

  def same_as(other_address)
    ![:full_name, :address1, :address2, :city, :country, :postal_code, :province].map {|attr| self.try_with_default(attr, '') == other_address.try_with_default(attr, '')}.include?(false)
  end

  def as_json(options={})
    {
      id: id,
      full_name: full_name,
      address1: address1,
      address2: address2,
      city: city,
      country: country,
      postal_code: postal_code,
      province: province,
      display_name: display_name(', ')
    }
  end

  def country_obj
    Country[country] || Country.find_country_by_name(country)
  end
end