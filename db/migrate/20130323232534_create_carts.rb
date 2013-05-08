class CreateCarts < ActiveRecord::Migration
  def change
    create_table :carts do |t|
      t.decimal  :subtotal, :precision => 11, :scale => 2
      t.string   :tax_name
      t.decimal  :tax_rate, :precision => 11, :scale => 2
      t.decimal  :shipping, :precision => 11, :scale => 2
      t.decimal  :total, :precision => 11, :scale => 2
      t.string   :coupon_code
      t.decimal  :coupon_amount, :precision => 11, :scale => 2
      t.boolean  :coupon_percentage
      t.string   :state

      t.timestamps
    end
  end
end