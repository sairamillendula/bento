class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.integer :buyable_id
      t.string  :buyable_type
      t.integer :quantity, default: 1
      t.decimal :price, :precision => 11, :scale => 2
      t.integer :cart_id
      t.integer :order_id

      t.timestamps
    end

    add_index :line_items, [:buyable_id, :buyable_type]
  end
end