class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.integer :product_id
      t.integer :product_variant_id
      t.integer :quantity, default: 1
      t.float   :price
      t.integer :cart_id
      t.integer :order_id

      t.timestamps
    end

    add_index :line_items, :product_id
    add_index :line_items, :product_variant_id
  end
end