class CreateProductOptions < ActiveRecord::Migration
  def change
    create_table :product_options do |t|
      t.references :product
      t.string :name
      t.string :values
      t.integer :position

      t.timestamps
    end
  end
end
