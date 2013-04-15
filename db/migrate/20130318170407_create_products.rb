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
      t.boolean :has_options, default: false

      t.timestamps
    end
  end
end