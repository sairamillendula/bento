class RegionTax < ActiveRecord::Base
  belongs_to :tax, counter_cache: true
end
