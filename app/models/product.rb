class Product < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper

  # FRIENDLY ID
  # ------------------------------------------------------------------------------------------------------
  extend FriendlyId
  friendly_id :slug, use: [:slugged, :history]
  include Sluggable


  # SEARCH
  # ------------------------------------------------------------------------------------------------------
  include PgSearch

  # Remember to run Product.sync_keywords! and PgSearch::Multisearch.rebuild(Product)
  # when changing this array.
  VARIANT_SEARCH_FIELDS = [:sku, :price]
  # rake pg_search:multisearch:rebuild[Product]
  # Product.search_by_keyword('00100')
  multisearchable :against => [:name, :slug, :keywords]
  pg_search_scope :search_by_keyword,
                  :against => [:name, :slug],
                  :associated_against => {
                    :all_variants => [:sku, :price]
                  },
                  :using => {
                    :tsearch => {
                      :prefix => true # match any characters
                    }
                  },
                  :ignoring => :accents


  # ASSOCIATIONS
  # ------------------------------------------------------------------------------------------------------
  has_many :all_variants, class_name: 'ProductVariant', dependent: :destroy

  has_many :variants, -> { where(active: true, master: false) }, class_name: "ProductVariant"
  accepts_nested_attributes_for :variants, allow_destroy: true, reject_if: proc {|attributes| attributes['selected'] != '1'}

  has_one :master, -> { where(master: true, active: true) }, class_name: "ProductVariant"
  accepts_nested_attributes_for :master

  has_many :options, class_name: "ProductOption", dependent: :destroy
  accepts_nested_attributes_for :options, allow_destroy: true

  has_many :pictures, lambda { order "position" }, as: :picturable, dependent: :destroy
  accepts_nested_attributes_for :pictures, allow_destroy: true

  has_many :product_relationships, dependent: :destroy
  has_many :cross_sells
  has_many :cross_sell_products, through: :cross_sells, source: :other_product

  has_many :line_items, through: :all_variants
  has_and_belongs_to_many :categories

  has_many :collection_products, dependent: :destroy
  has_many :collections, through: :collection_products

  has_and_belongs_to_many :suppliers
  has_many :stocks
  has_many :orders, lambda { uniq }, through: :line_items
  has_many :reviews, class_name: "ProductReview", dependent: :destroy


  # SCOPES
  # ------------------------------------------------------------------------------------------------------
  scope :visibles,         -> { where(visible: true) }
  scope :in_stocks,        -> { where('in_stock > ?', 0) }
  scope :exclude_products, -> (product_ids) { where("id NOT IN (?)", product_ids) }
  scope :active,           -> { where(active: true) }
  scope :top_sellers,      -> { where("orders_count > 0").order(:orders_count).limit(10)}
  #scope :on_sales, -> { joins(:master).where("variants.reduced_price > 0") }
  scope :on_sale, -> { includes('all_variants').where("product_variants.reduced_price > 0").references('product_variants') }


  # ATTRIBUTES
  # ------------------------------------------------------------------------------------------------------
  attr_reader :category_tokens, :supplier_tokens, :cross_sell_tokens
  attr_accessor :has_options, :auto_generate_variants

  store :meta_tag, accessors: [:seo_title, :seo_description]


  # VALIDATIONS
  # ------------------------------------------------------------------------------------------------------
  validates_uniqueness_of :name
  validates_presence_of :name, :slug, :description


  # CALLBACKS
  # ------------------------------------------------------------------------------------------------------
  before_create :generate_sku, :if => Proc.new { |product| product.master.sku.blank? }
  # before_save { |product| product.in_stock = 0 if product.in_stock.to_i < 0 }
  before_validation :generate_variants, :if => :new_record?
  before_create :clean_up
  before_destroy { |product|
    unless product.can_be_deleted?
      product.update_attribute(:active, false)
    end
    return product.can_be_deleted?
  }
  before_save :sync_keywords


  # CLASS METHODS
  # ------------------------------------------------------------------------------------------------------
  def self.sync_keywords!
    all.each &:sync_keywords!
  end


  # INSTANCE METHODS
  # ------------------------------------------------------------------------------------------------------
  def to_param
    slug
  end

  def sync_keywords
    self.keywords = VARIANT_SEARCH_FIELDS.inject([]) do |mem, obj|
      mem += all_variants.map(&obj)
    end
    self.keywords = keywords.join ' '
  end

  def sync_keywords!
    sync_keywords and save
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
    master && master.reduced_price.present? && master.reduced_price > 0
  end

  def current_price
    master.reduced_price.present? ? master.reduced_price : master.price
  end

  def price_display(currency = 'USD')
    # products have at least 1 variant (master)
    begin
      price = Money.us_dollar(master.current_price * 100).exchange_to(currency)
    rescue Money::Bank::UnknownRate
      price = Money.us_dollar(master.current_price * 100).exchange_to('USD')
    end
    product_variants_count > 1 ? "#{I18n.t('theme.from_price', default: 'From')} #{price.symbol} #{price} #{currency}" : "#{price.symbol} #{price} #{currency}"
  end

  def percentage_off
    (1 - (master.reduced_price/master.price))*100 if master.reduced_price
  end

  def price_margin
    (master.price - (master.cost_price || 0)) / (master.cost_price || 0) * 100
  end

  def in_stock?
    master.in_stock > 0
  end

  def can_be_deleted?
    return false if (variants && variants.select{|x| !x.can_be_deleted?}.any?)
  	!(orders_count > 0)
  end

  def generate_variants
    if has_options
      temp = variants.dup unless auto_generate_variants
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
              price: master.price,
              reduced_price: master.reduced_price,
              in_stock: master.in_stock
            )
          else
            variants << existings[opts]
          end
        end
      end
    else
      options.clear
    end
  end

  def photo_mapping
    @photos ||= pictures.index_by(&:name)
  end

  alias_attribute :cart_name, :name

  def has_options
    ActiveRecord::ConnectionAdapters::Column.value_to_boolean(@has_options)
  end

  def auto_generate_variants
    ActiveRecord::ConnectionAdapters::Column.value_to_boolean(@auto_generate_variants)
  end

  def quick_pictures
    pictures.limit(2).order('position')
  end

  def self.to_csv(options={}, host_with_port)
    headers = %w{id title description condition price availability link image_link google_product_category}
    header_indexes = Hash[headers.map.with_index{|*x| x}]

    #renderer = Redcarpet::Render::HTML.new(no_links: true, hard_wrap: true)

    CSV.generate(options) do |csv|
      csv << headers
      Product.visibles.each do |product|
        data = {}
          data["id"] = product.master.sku
          data["title"] = product.name
          data["description"] = "#{product.name} is a japanese bento lunch box to bring your meal on the go." # Redcarpet::Markdown.new(renderer, options).render(product.description)
          data["condition"] = "new"
          data["price"] = product.current_price
          data["availability"] = "in stock"
          data["link"] = "#{host_with_port}/products/#{product.slug}"
          data["image_link"] = "#{host_with_port}#{product.pictures.first.upload.url(:thumb, size: '200x200')}" if product.pictures.any?
          data["google_product_category"] = "Home & Garden > Kitchen & Dining > Food & Beverage Carriers > Lunch Boxes & Totes"
          data["shipping"] = "US:::6.00"
          data["tax"] = "US:0"

          row = []
          header_indexes.each do |field, index|
            row << data[field] || ''
          end
          csv << row
      end
    end
  end

  private

    def generate_sku
      last_product_id = Product.last.present? ? Product.last.id : 0
      self.master.sku = "%05d" % (last_product_id + 1)
    end

    def clean_up
      variants.each {|v| v.selected = '1'} if auto_generate_variants
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
