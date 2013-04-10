class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string  :name
      t.string  :slug
      t.string  :sku
      t.decimal :price, :precision => 11, :scale => 2
      t.decimal :sale_price, :precision => 11, :scale => 2
      t.text    :description
      t.boolean :public, default: true
      t.boolean :back_ordered, default: false
      t.boolean :featured, default: false
      t.integer :supplier_id

      t.timestamps
    end
  end
end