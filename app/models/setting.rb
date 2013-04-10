class Setting < ActiveRecord::Base  
  attr_accessible :key, :value
  validates_presence_of :key, :value
  validates_uniqueness_of :key
  
  scope :facebook, where(key: 'facebook').limit(1)
  scope :twitter, where(key: 'twitter').limit(1)
  scope :min_amount_for_free_shipping, where(key: 'min_amount_for_free_shipping').limit(1)
  
  KEYS = %w{twitter facebook min_amount_for_free_shipping}
  
  KEYS.each do |method|
    define_method "#{method.downcase}" do
      self.key == method
    end
  end

end
