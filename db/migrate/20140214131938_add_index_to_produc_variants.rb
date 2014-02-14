class AddIndexToProducVariants < ActiveRecord::Migration
  def change
    add_index :product_variants, [:master, :active], :name => "product_variants_master_active_index"
  end
end
