# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130412223005) do

  create_table "addresses", :force => true do |t|
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "province"
    t.string   "postal_code"
    t.string   "country"
    t.string   "type"
    t.integer  "addressable_id"
    t.string   "addressable_type"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "addresses", ["addressable_id"], :name => "index_addresses_on_addressable_id"
  add_index "addresses", ["addressable_type"], :name => "index_addresses_on_addressable_type"
  add_index "addresses", ["type"], :name => "index_addresses_on_type"

  create_table "articles", :force => true do |t|
    t.string   "title"
    t.string   "slug"
    t.boolean  "visible",    :default => true
    t.text     "content"
    t.text     "meta_tag"
    t.integer  "author_id"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "articles", ["slug"], :name => "index_articles_on_slug"

  create_table "articles_tags", :id => false, :force => true do |t|
    t.integer "article_id"
    t.integer "tag_id"
  end

  add_index "articles_tags", ["article_id"], :name => "index_articles_tags_on_article_id"
  add_index "articles_tags", ["tag_id"], :name => "index_articles_tags_on_tag_id"

  create_table "audit_trails", :force => true do |t|
    t.boolean  "success",        :default => true
    t.text     "message"
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  create_table "audit_years", :force => true do |t|
    t.integer  "year"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "carts", :force => true do |t|
    t.decimal  "subtotal",          :precision => 11, :scale => 2
    t.decimal  "tax",               :precision => 11, :scale => 2
    t.decimal  "shipping",          :precision => 11, :scale => 2
    t.decimal  "total",             :precision => 11, :scale => 2
    t.string   "coupon_code"
    t.decimal  "coupon_amount",     :precision => 11, :scale => 2
    t.boolean  "coupon_percentage"
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "categories_products", :id => false, :force => true do |t|
    t.integer "category_id"
    t.integer "product_id"
  end

  add_index "categories_products", ["category_id"], :name => "index_categories_products_on_category_id"
  add_index "categories_products", ["product_id"], :name => "index_categories_products_on_product_id"

  create_table "coupons", :force => true do |t|
    t.string   "code"
    t.decimal  "amount",     :precision => 11, :scale => 2
    t.boolean  "percentage",                                :default => true
    t.boolean  "active",                                    :default => true
    t.datetime "created_at",                                                  :null => false
    t.datetime "updated_at",                                                  :null => false
  end

  add_index "coupons", ["code"], :name => "index_coupons_on_code"

  create_table "friendly_id_slugs", :force => true do |t|
    t.string   "slug",                         :null => false
    t.integer  "sluggable_id",                 :null => false
    t.string   "sluggable_type", :limit => 40
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type"], :name => "index_friendly_id_slugs_on_slug_and_sluggable_type", :unique => true
  add_index "friendly_id_slugs", ["sluggable_id"], :name => "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], :name => "index_friendly_id_slugs_on_sluggable_type"

  create_table "line_items", :force => true do |t|
    t.integer  "product_id"
    t.integer  "product_variant_id"
    t.integer  "quantity",                                          :default => 1
    t.decimal  "price",              :precision => 11, :scale => 2
    t.integer  "cart_id"
    t.integer  "order_id"
    t.datetime "created_at",                                                       :null => false
    t.datetime "updated_at",                                                       :null => false
  end

  add_index "line_items", ["product_id"], :name => "index_line_items_on_product_id"
  add_index "line_items", ["product_variant_id"], :name => "index_line_items_on_product_variant_id"

  create_table "meta_tags", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "meta_taggable_id"
    t.string   "meta_taggable_type"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "orders", :force => true do |t|
    t.string   "code"
    t.integer  "user_id"
    t.decimal  "subtotal",              :precision => 11, :scale => 2
    t.decimal  "tax",                   :precision => 11, :scale => 2
    t.decimal  "shipping",              :precision => 11, :scale => 2
    t.decimal  "total",                 :precision => 11, :scale => 2
    t.boolean  "completed",                                            :default => false
    t.string   "payment_type"
    t.string   "coupon_code"
    t.string   "remote_ip"
    t.boolean  "shipped",                                              :default => false
    t.datetime "shipped_at"
    t.string   "stripe_customer_token"
    t.string   "currency"
    t.string   "card_type"
    t.string   "last4"
    t.datetime "created_at",                                                              :null => false
    t.datetime "updated_at",                                                              :null => false
  end

  add_index "orders", ["user_id"], :name => "index_orders_on_user_id"

  create_table "pages", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.boolean  "visible",    :default => true
    t.string   "klass"
    t.text     "content"
    t.text     "meta_tag"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "pages", ["slug"], :name => "index_pages_on_slug"

  create_table "pictures", :force => true do |t|
    t.integer  "picturable_id"
    t.string   "picturable_type"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "name"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "product_options", :force => true do |t|
    t.integer  "product_id"
    t.string   "name"
    t.string   "values"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "product_relationships", :force => true do |t|
    t.integer  "product_id"
    t.integer  "other_product_id"
    t.string   "type"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "product_variants", :force => true do |t|
    t.string   "name"
    t.decimal  "price",      :precision => 11, :scale => 2
    t.integer  "in_stock",                                  :default => 0
    t.integer  "product_id"
    t.datetime "created_at",                                               :null => false
    t.datetime "updated_at",                                               :null => false
  end

  add_index "product_variants", ["product_id"], :name => "index_product_variants_on_product_id"

  create_table "products", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "sku"
    t.decimal  "price",       :precision => 11, :scale => 2
    t.decimal  "sale_price",  :precision => 11, :scale => 2
    t.text     "description"
    t.boolean  "visible",                                    :default => true
    t.boolean  "featured",                                   :default => false
    t.integer  "in_stock",                                   :default => 0
    t.integer  "supplier_id"
    t.text     "meta_tag"
    t.boolean  "has_options",                                :default => false
    t.datetime "created_at",                                                    :null => false
    t.datetime "updated_at",                                                    :null => false
  end

  create_table "products_suppliers", :id => false, :force => true do |t|
    t.integer "product_id"
    t.integer "supplier_id"
  end

  add_index "products_suppliers", ["product_id"], :name => "index_products_suppliers_on_product_id"
  add_index "products_suppliers", ["supplier_id"], :name => "index_products_suppliers_on_supplier_id"

  create_table "reseller_requests", :force => true do |t|
    t.integer  "user_id"
    t.boolean  "approved",      :default => false
    t.string   "business_name"
    t.string   "country"
    t.string   "city"
    t.text     "who_are_you"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  create_table "settings", :force => true do |t|
    t.string   "key"
    t.text     "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "settings", ["key"], :name => "index_settings_on_key"

  create_table "stocks", :force => true do |t|
    t.integer  "in_stock",           :default => 0
    t.integer  "product_id"
    t.integer  "product_variant_id"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  add_index "stocks", ["product_id"], :name => "index_stocks_on_product_id"
  add_index "stocks", ["product_variant_id"], :name => "index_stocks_on_product_variant_id"

  create_table "suppliers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                              :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "active",                          :default => true
    t.boolean  "admin",                           :default => false
    t.boolean  "reseller",                        :default => false
    t.string   "localization",                    :default => "en"
    t.string   "crypted_password"
    t.string   "salt"
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
  end

  add_index "users", ["remember_me_token"], :name => "index_users_on_remember_me_token"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token"

end
