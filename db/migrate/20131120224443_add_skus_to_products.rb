class AddSkusToProducts < ActiveRecord::Migration
  def change
    add_column :products, :skus, :string
  end
end
