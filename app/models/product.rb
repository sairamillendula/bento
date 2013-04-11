class Product < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
	extend FriendlyId
  friendly_id :slug, use: [:slugged, :history]

  has_many :variants, class_name: "ProductVariant", dependent: :destroy
  accepts_nested_attributes_for :variants, allow_destroy: true, reject_if: Proc.new {|v| v['name'].blank?}

  has_many :pictures, as: :picturable, dependent: :destroy
  accepts_nested_attributes_for :pictures, allow_destroy: true

  has_many :line_items
  has_and_belongs_to_many :categories
  has_many :stocks

  scope :public, where(public: true)
  scope :in_stocks, where('in_stock > ?', 0)
  
  attr_accessible :name, :description, :sale_price, :price, :public, :sku, :slug, :featured, :supplier_id, :in_stock, :variants_attributes, 
                  :category_tokens, :pictures_attributes
  attr_reader :category_tokens
  
  validates_uniqueness_of :name, :sku
  validates_presence_of :name, :price, :slug, :description
  validates :price, numericality: {greater_than_or_equal_to: 0.01}
  validates :sale_price, numericality: { greater_than_or_equal_to: 0.01 }, allow_blank: true
  
  before_create :generate_sku

  def to_param
    slug
  end

  def category_tokens=(tokens)
    self.category_ids = Category.ids_from_tokens(tokens)
  end

  def on_sale?
    sale_price.present? && sale_price > 0
  end

  def current_price
    sale_price.present? ? sale_price : price
  end

  def price_display
    variants.any? ? "#{I18n.t('from_price')} #{number_to_currency(price)}" : "#{number_to_currency(price)}"
  end
  
  def in_stock?
    in_stock > 0
  end

  def can_be_deleted?
  	line_items.empty?
  end

private

  def generate_sku
    last_product_id = Product.last.present? ? Product.last.id : 0
    self.sku = "%05d" % (last_product_id + 1)
  end

end