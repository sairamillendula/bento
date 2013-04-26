class RegionTax < ActiveRecord::Base
  belongs_to :tax, :counter_cache => true
  attr_accessible :name, :province, :rate
end
