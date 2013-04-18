class CreateProductVariants < ActiveRecord::Migration
  def change
    create_table :product_variants do |t|
    	t.text    :options
      t.decimal :price, precision: 11, scale: 2
      t.integer :in_stock, default: 0
    	t.integer :product_id

      t.timestamps
    end

    add_index :product_variants, :product_id
  end
end