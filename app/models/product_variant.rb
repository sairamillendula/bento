class ProductVariant < ActiveRecord::Base
  belongs_to :product

  has_many :pictures, as: :picturable, dependent: :destroy
  accepts_nested_attributes_for :pictures, allow_destroy: true

  has_many :stocks

  scope :in_stocks, where(back_ordered: false && in_stock > 0)

  attr_accessible :name, :price, :sale_price, :description, :back_ordered, :featured, :product_id, :pictures_attributes, :in_stock

  validates_presence_of :name
  validates_uniqueness_of :name, scope: :product_id
  
  def current_price
  	sale_price.present? ? sale_price : (price.present? ? price : product.price)
  end

  def on_sale?
    sale_price.present? && sale_price > 0
  end

  def in_stock?
    in_stock > 0
  end
  
  def can_be_deleted?
    line_items.any?
  end

end