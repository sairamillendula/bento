class AddRecoveredToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :recovered, :boolean, default: false
  end
end
