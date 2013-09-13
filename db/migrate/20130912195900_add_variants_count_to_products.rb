class AddVariantsCountToProducts < ActiveRecord::Migration
  def change
    add_column :products, :product_variants_count, :integer, default: 0, null: false
  end
end