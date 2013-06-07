class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string  :name
      t.string  :slug
      t.string  :sku
      t.text    :description
      t.boolean :visible, default: true
      t.boolean :featured, default: false
      t.integer :supplier_id
      t.text    :meta_tag
      t.integer :orders_count, default: 0
      t.boolean :active, default: true

      t.timestamps
    end
  end
end