class ProductVariant < ActiveRecord::Base
  belongs_to :product

  has_many :pictures, as: :picturable, dependent: :destroy
  accepts_nested_attributes_for :pictures, allow_destroy: true

  has_many :stocks

  scope :in_stocks, where('in_stock > ?', 0)

  attr_accessible :price, :in_stock, :product_id, :pictures_attributes, :option1, :option2, :option3

  # validates_presence_of :name
  # validates_uniqueness_of :name, scope: :product_id
  before_save { |variant| variant.in_stock = 0 if variant.in_stock.to_i < 0 }

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

  def name
    options.values.join(" / ")
  end

end