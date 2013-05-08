class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
    	t.string   :code
    	t.integer  :user_id
      t.decimal  :subtotal, :precision => 11, :scale => 2
      t.string   :tax_name
      t.decimal  :tax_rate, :precision => 11, :scale => 2
      t.string   :shipping_method
      t.decimal  :shipping_price, :precision => 11, :scale => 2
      t.decimal  :total, :precision => 11, :scale => 2
      t.string   :coupon_code
      t.decimal  :coupon_amount, :precision => 11, :scale => 2
      t.boolean  :coupon_percentage
      t.string   :remote_ip
      t.datetime :shipped_at
      t.string   :stripe_card_token
      t.string   :currency
      t.string   :card_type
      t.string   :last4
      t.string   :state

      t.timestamps
    end

    add_index :orders, :user_id
  end
end