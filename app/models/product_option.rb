class ProductOption < ActiveRecord::Base
  acts_as_list scope: :product
  
  # ASSOCIATIONS
  # ------------------------------------------------------------------------------------------------------
  belongs_to :product
  

  # VALIDATIONS
  # ------------------------------------------------------------------------------------------------------
  validates_uniqueness_of :name, scope: :product_id
  validates_presence_of :name
  

  # CALLBACKS
  # ------------------------------------------------------------------------------------------------------
  after_destroy :remove_option_from_variants
  

  # INSTANCE METHODS
  # ------------------------------------------------------------------------------------------------------
  def destroyable?
    !(product && product.variants.map(&:options).map{|opts| opts.except(:"option#{position}")}.find_dups.size > 0)
  end

  def remove_option_from_variants
    product.variants.each do |variant|
      new_options = variant.options.except(:"option#{position}").each.with_index.inject({}) {|h, ((k, v), index)| h[:"option#{index + 1}"] = v; h }
      variant.options = new_options
      variant.save
    end
  end
  
end
