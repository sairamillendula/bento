class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.string  :code
      t.decimal :amount, :precision => 11, :scale => 2
      t.boolean :percentage, default: true
      t.boolean :active, default: true
      t.integer :orders_count, default: 0

      t.timestamps
    end

    add_index :coupons, :code
  end
end