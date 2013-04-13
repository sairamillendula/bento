class Product < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
	extend FriendlyId
  friendly_id :slug, use: [:slugged, :history]

  # ASSOCICATIONS
  # -------------
  has_many :variants, class_name: "ProductVariant", dependent: :destroy
  accepts_nested_attributes_for :variants, allow_destroy: true, reject_if: Proc.new {|v| v['name'].blank?}

  has_many :options, class_name: "ProductOption", dependent: :destroy
  accepts_nested_attributes_for :options, allow_destroy: true

  has_many :pictures, as: :picturable, dependent: :destroy
  accepts_nested_attributes_for :pictures, allow_destroy: true

  has_many :product_relationships, dependent: :destroy
  has_many :cross_sells
  has_many :cross_sell_products, through: :cross_sells, source: :other_product

  has_many :line_items
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :suppliers
  has_many :stocks

  has_one :meta_tag, as: :meta_taggable, dependent: :destroy
  accepts_nested_attributes_for :meta_tag

  # SCOPES
  # -------------
  scope :public, where(public: true)
  scope :in_stocks, where('in_stock > ?', 0)
  
  # ATTRIBUTES
  # -------------
  attr_accessible :name, :description, :sale_price, :price, :public, :sku, :slug, :featured, :supplier_id, :in_stock, :variants_attributes, 
                  :category_tokens, :supplier_tokens, :pictures_attributes, :cross_sell_tokens, :has_options, :options_attributes,
                  :meta_tag_attributes
  attr_reader :category_tokens, :supplier_tokens, :cross_sell_tokens
  
  # VALIDATIONS
  # -------------
  validates_uniqueness_of :name, :sku
  validates_presence_of :name, :price, :slug, :description
  validates :price, numericality: {greater_than_or_equal_to: 0.01}
  validates :sale_price, numericality: { greater_than_or_equal_to: 0.01 }, allow_blank: true
  
  # CALLBACKS
  # -------------
  before_create :generate_sku
  before_save { |product| product.in_stock = 0 if product.in_stock.to_i < 0 }

  def to_param
    slug
  end

  def category_tokens=(tokens)
    self.category_ids = Category.ids_from_tokens(tokens)
  end

  def supplier_tokens=(tokens)
    self.supplier_ids = Supplier.ids_from_tokens(tokens)
  end

  def cross_sell_tokens=(tokens)
    self.cross_sell_products.destroy_all
    Product.where(id: tokens.split(',').reject {|crsid| crsid == self.id.to_s}).each do |product|
      self.cross_sell_products << product
    end
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