class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.string  :code
      t.string  :amount
      t.boolean :percentage, default: true
      t.boolean :active, default: true

      t.timestamps
    end

    add_index :coupons, :code
  end
end