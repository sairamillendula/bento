class AddUserIdToCarts < ActiveRecord::Migration
  def change
    add_column :carts, :user_id, :integer
    add_column :carts, :reminded, :boolean, default: false
    add_column :carts, :reminded_at, :datetime

    add_index :carts, :user_id
  end
end
