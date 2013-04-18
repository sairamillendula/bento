class CreateCollectionsProducts < ActiveRecord::Migration
  def change
  	create_table :collections_products, id: false do |t|
  		t.references :collection
  		t.references :product
  		t.integer    :position, default: 1
  	end

  	add_index :collections_products, :collection_id
    add_index :collections_products, :product_id
  end
end