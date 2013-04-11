class CreateProductsSuppliers < ActiveRecord::Migration
  def change
  	create_table :products_suppliers, id: false do |t|
  		t.references :product
  		t.references :supplier
  	end

  	add_index :products_suppliers, :product_id
    add_index :products_suppliers, :supplier_id
  end
end