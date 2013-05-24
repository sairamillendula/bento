class Product < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
	extend FriendlyId
  friendly_id :slug, use: [:slugged, :history]
  include Sluggable

  # ASSOCICATIONS
  # -------------
  has_many :variants, class_name: "ProductVariant", dependent: :destroy, :conditions  => { :active => true }
  accepts_nested_attributes_for :variants, allow_destroy: true, reject_if: proc {|attributes| attributes['selected'] != '1'}

  has_many :options, class_name: "ProductOption", dependent: :destroy
  accepts_nested_attributes_for :options, allow_destroy: true

  has_many :pictures, as: :picturable, dependent: :destroy, order: "position"
  accepts_nested_attributes_for :pictures, allow_destroy: true

  has_many :product_relationships, dependent: :destroy
  has_many :cross_sells
  has_many :cross_sell_products, through: :cross_sells, source: :other_product

  has_many :line_items, as: :buyable
  has_and_belongs_to_many :categories

  has_many :collection_products, dependent: :destroy
  has_many :collections, through: :collection_products

  has_and_belongs_to_many :suppliers
  has_many :stocks
  has_many :orders, through: :line_items, uniq: true
  has_many :reviews, class_name: "ProductReview", dependent: :destroy

  store :meta_tag, accessors: [:seo_title, :seo_description]

  # SCOPES
  # -------------
  scope :visibles, where(visible: true)
  scope :in_stocks, where('in_stock > ?', 0)
  scope :exclude_products, lambda {|product_ids| where("id NOT IN (?)", product_ids)}
  scope :active, where(active: true)
  
  # ATTRIBUTES
  # -------------
  attr_accessible :name, :description, :reduced_price, :price, :visible, :sku, :slug, :featured, :supplier_id, :in_stock, :variants_attributes, 
                  :category_tokens, :supplier_tokens, :pictures_attributes, :cross_sell_tokens, :has_options, :options_attributes,
                  :meta_tag, :seo_title, :seo_description, :auto_generate_variants
  attr_reader :category_tokens, :supplier_tokens, :cross_sell_tokens
  attr_accessor :has_options, :auto_generate_variants
  
  # VALIDATIONS
  # -------------
  validates_uniqueness_of :name, :sku
  validates_presence_of :name, :price, :slug, :description
  validates_numericality_of :price, greater_than_or_equal_to: 0.01
  validates_numericality_of :reduced_price, greater_than_or_equal_to: 0.01, allow_blank: true
  validates_numericality_of :in_stock, only_integer: true
  
  # CALLBACKS
  # -------------
  before_create :generate_sku, :if => Proc.new { |product| product.sku.empty? }
  before_save { |product| product.in_stock = 0 if product.in_stock.to_i < 0 }
  before_validation :generate_variants, :if => :new_record?
  before_create :clean_up
  before_destroy { |product|
    unless product.can_be_deleted?
      product.update_attribute(:active, false)
    end
    return product.can_be_deleted?
  }
  
  # INSTANCE METHODS
  # -------------
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
    reduced_price.present? && reduced_price > 0
  end

  def current_price
    reduced_price.present? ? reduced_price : price
  end

  def price_display
    variants.any? ? "#{I18n.t('from_price')} #{number_to_currency(price)}" : "#{number_to_currency(price)}"
  end

  def percentage_off
    (1 - (reduced_price/price))*100 if reduced_price
  end
  
  def in_stock?
    in_stock > 0
  end

  def can_be_deleted?
    return false if (variants && variants.select{|x| !x.can_be_deleted?}.any?)
  	!(orders_count > 0)
  end

  def generate_variants
    temp = variants.dup unless auto_generate_variants == '1'
    variants.destroy_all

    if options.size > 0
      existings = temp ? temp.index_by{|v| v.options.symbolize_keys} : {}
      result = []
      result = pushOpt(options[0].values.try(:split, ',') || [], []) if options[0]
      result = pushOpt(result, options[1].values.try(:split, ',') || []) if options[1]
      result = pushOpt(result, options[2].values.try(:split, ',') || []) if options[2]
      result.each do |variant_options|
        opts = variant_options.each.with_index.inject({}) {|h, (opt, idx)| h[:"option#{idx + 1}"] = opt; h }
        unless existings[opts]
          variants.build(
            options: opts,
            price: price,
            in_stock: in_stock
          )
        else
          variants << existings[opts]
        end
      end
    end
  end

  alias_attribute :cart_name, :name

private

  def generate_sku
    last_product_id = Product.last.present? ? Product.last.id : 0
    self.sku = "%05d" % (last_product_id + 1)
  end

  def clean_up
    variants.each {|v| v.selected = '1'} if auto_generate_variants == '1'
    variants.each {|v| v.mark_for_destruction unless v.selected == '1'}
  end

  def pushOpt(arr1, arr2)
    result = []
    for v1 in arr1
      if arr2.size > 0
        for v2 in arr2
          if v1.kind_of?(Array)
            tmp = v1.dup
            tmp << v2
            result << tmp
          else
            result << [v1, v2]
          end
        end
      else
        result << [v1]
      end
    end
    result
  end

end