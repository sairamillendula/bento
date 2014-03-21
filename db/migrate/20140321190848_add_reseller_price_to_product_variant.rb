class AddResellerPriceToProductVariant < ActiveRecord::Migration
  def change
  	add_column :product_variants, :reseller_price, :decimal, precision: 11, scale: 2
  	add_column :product_variants, :min_quantity_for_reseller_order, :integer, default: 1
  end
end
