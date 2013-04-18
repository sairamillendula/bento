class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string  :name
      t.string  :slug
      t.string  :sku
      t.decimal :price, precision: 11, scale: 2
      t.decimal :sale_price, precision: 11, scale: 2
      t.text    :description
      t.boolean :visible, default: true
      t.boolean :featured, default: false
      t.integer :in_stock, default: 0
      t.integer :supplier_id
      t.text    :meta_tag
      t.boolean :has_options, default: false
      t.integer :orders_count, default: 0
      t.boolean :auto_generate_variants, default: true

      t.timestamps
    end
  end
end