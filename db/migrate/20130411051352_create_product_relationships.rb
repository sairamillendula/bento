class CreateProductRelationships < ActiveRecord::Migration
  def change
    create_table :product_relationships do |t|
      t.integer :product_id
      t.integer :other_product_id
      t.string  :type

      t.timestamps
    end
  end
end
