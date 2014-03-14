class AddDefaultsToProductVariant < ActiveRecord::Migration
  def up
    change_column_default('product_variants', 'price', 0)
    change_column_default('product_variants', 'reduced_price', 0)
    change_column_default('product_variants', 'cost_price', 0)
  end
  def down
    change_column_default('product_variants', 'price', nil)
    change_column_default('product_variants', 'reduced_price', nil)
    change_column_default('product_variants', 'cost_price', nil)
  end
end
