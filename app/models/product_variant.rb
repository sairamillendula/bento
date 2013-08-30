class ProductVariant < ActiveRecord::Base
  # ASSOCIATIONS
  # -------------
  belongs_to :product

  has_many :pictures, as: :picturable, dependent: :destroy
  accepts_nested_attributes_for :pictures, allow_destroy: true

  has_many :stocks
  has_many :line_items
  has_many :orders, through: :line_items, uniq: true
  
  # SCOPES
  # -------------
  scope :in_stocks, where('in_stock > ?', 0)
  scope :active, where(active: true)
  
  # ATTRIBUTES
  # -------------
  attr_accessor :selected
  attr_accessible :price, :reduced_price, :in_stock, :product_id, :pictures_attributes, :selected, :options, :sku, :cost_price

  serialize :options, ActiveRecord::Coders::Hstore

  %w[option1 option2 option3].each do |key|
    attr_accessible key
    scope "has_#{key}", lambda { |value| where("options @> hstore(?, ?)", key, value) }
    
    define_method(key) do
      options && options[key]
    end
  
    define_method("#{key}=") do |value|
      self.options = (options || {}).merge(key => value)
    end
  end
  
  # VALIDATIONS
  # -------------
  # validates :options, uniqueness: {scope: :product_id, message: Proc.new {|error, attributes| "'#{YAML.load(attributes[:value]).values.join(' / ')}' is duplicated"} }
  validates :options, uniqueness: {scope: :product_id}, unless: :master?
  validate :validate_options_presence, unless: :master?
  validates_numericality_of :price, greater_than_or_equal_to: 0.0, allow_blank: true
  validates_numericality_of :reduced_price, greater_than_or_equal_to: 0.01, allow_blank: true
  validates_numericality_of :in_stock, only_integer: true
  validates_presence_of :price
  validates_uniqueness_of :sku, allow_blank: true

  before_save { |variant| variant.in_stock = 0 if variant.in_stock.to_i < 0 }
  after_save :update_product_options

  before_destroy { |variant|
    unless variant.can_be_deleted?
      variant.update_attribute(:active, false)
    end
    return variant.can_be_deleted?
  }
  
  # INSTANCE METHODS
  # -------------  
  def current_price
  	price.present? ? price : product.master.price
  end

  def in_stock?
    in_stock > 0
  end
  
  def can_be_deleted?
    !(orders_count > 0)
  end

  def on_sale?
    reduced_price.present? && reduced_price > 0
  end

  def name(html=false)
    if html
      options.values.reject{|v| v.blank?}.map.with_index {|v, idx| "<span class=\"option-#{idx + 1}\">#{v}</span>"}.join(' / ').html_safe
    else
      options.values.reject{|v| v.blank?}.join(' / ')
    end
  end

  def cart_name
    if master
      product.name
    else
      "#{product.name} (#{name})"
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