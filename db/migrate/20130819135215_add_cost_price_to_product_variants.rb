class AddCostPriceToProductVariants < ActiveRecord::Migration
  def change
    add_column :product_variants, :cost_price, :decimal, precision: 11, scale: 2
  end
end