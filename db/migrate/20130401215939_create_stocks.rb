class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|
      t.integer :in_stock, default: 0
      t.integer :product_id
      t.integer :product_variant_id

      t.timestamps
    end

    add_index :stocks, :product_id
    add_index :stocks, :product_variant_id
  end
end