class CreateProductVariants < ActiveRecord::Migration
  def change
    create_table :product_variants do |t|
    	t.hstore  :options
      t.decimal :price, precision: 11, scale: 2
      t.decimal :reduced_price, precision: 11, scale: 2
      t.integer :in_stock, default: 0
      t.integer :product_id
    	t.integer :orders_count, default: 0
      t.boolean :active, default: true
      t.boolean :master, default: false
      t.string  :sku

      t.timestamps
    end

    add_index :product_variants, :product_id
    add_index :product_variants, :options, using: :gin
  end
end