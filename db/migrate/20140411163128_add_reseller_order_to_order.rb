class AddResellerOrderToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :reseller_order, :boolean, default: false
  end
end
