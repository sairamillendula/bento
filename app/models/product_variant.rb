class ProductVariant < ActiveRecord::Base
  belongs_to :product

  has_many :pictures, as: :picturable, dependent: :destroy
  accepts_nested_attributes_for :pictures, allow_destroy: true

  has_many :stocks

  scope :in_stocks, where('in_stock > ?', 0)

  attr_accessor :selected
  attr_accessible :price, :in_stock, :product_id, :pictures_attributes, :option1, :option2, :option3, :selected, :options

  validates :options, uniqueness: {scope: :product_id, message: Proc.new {|error, attributes| "'#{YAML.load(attributes[:value]).values.join(' / ')}' is duplicated"} }
  validates :price, numericality: {greater_than_or_equal_to: 0.0, allow_blank: true}
  validate :validate_options_presence

  before_save { |variant| variant.in_stock = 0 if variant.in_stock.to_i < 0 }
  after_save :update_product_options

  store :options, accessors: [:option1, :option2, :option3]
  
  def current_price
  	price.present? ? price : product.price
  end

  def in_stock?
    in_stock > 0
  end
  
  def can_be_deleted?
    line_items.any?
  end

  def name(html=false)
    if html
      options.values.reject{|v| v.blank?}.map.with_index {|v, idx| "<span class=\"option-#{idx + 1}\">#{v}</span>"}.join(' / ').html_safe
    else
      options.values.reject{|v| v.blank?}.join(' / ')
    end
  end

private

  def update_product_options
    product.options.each do |opt|
      current_values = opt.values.try(:split, ',') || []
      val = send(:"option#{opt.position}")
      unless current_values.include?(val)
        current_values << val
        opt.values = current_values.join(',')
        opt.save
      end
    end
  end

  def validate_options_presence
    errors.add :options, "can't be blank" if options.values.map {|v| v.presence}.compact.blank?
  end

end