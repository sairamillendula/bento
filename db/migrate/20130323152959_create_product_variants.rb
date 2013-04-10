class CreateProductVariants < ActiveRecord::Migration
  def change
    create_table :product_variants do |t|
    	t.string  :name
    	t.float   :price
      t.float   :sale_price
    	t.text    :description
    	t.boolean :back_ordered, default: false
    	t.integer :product_id

      t.timestamps
    end

    add_index :product_variants, :product_id
  end
end