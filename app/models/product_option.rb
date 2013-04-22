class ProductOption < ActiveRecord::Base
  acts_as_list :scope => :product
  belongs_to :product
  attr_accessible :name, :product, :values, :position

  validates_uniqueness_of :name, :scope => :product_id
  validates_presence_of :name

  after_destroy :remove_option_from_variants

  def destroyable?
    !(product && product.variants.map(&:options).map{|opts| opts.except(:"option#{position}")}.find_dups.size > 0)
  end

  def remove_option_from_variants
    product.variants.each do |variant|
      variant.options = variant.options.except(:"option#{position}")
      variant.save
    end
  end
end
