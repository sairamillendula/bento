class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string  :name
      t.string  :slug
      t.string  :sku
      t.decimal :price, precision: 11, scale: 2
      t.decimal :reduced_price, precision: 11, scale: 2
      t.text    :description
      t.boolean :visible, default: true
      t.boolean :featured, default: false
      t.integer :in_stock, default: 0
      t.integer :supplier_id
      t.text    :meta_tag
      t.integer :orders_count, default: 0

      t.timestamps
    end
  end
end