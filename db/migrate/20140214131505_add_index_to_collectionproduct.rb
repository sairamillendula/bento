class AddIndexToCollectionproduct < ActiveRecord::Migration
  def change
    add_index :collection_products, [:position], :name => "collection_products_position_index"
  end
end
