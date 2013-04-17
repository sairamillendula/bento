class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
    	t.string   :code
    	t.integer  :user_id
      t.decimal  :subtotal, :precision => 11, :scale => 2
      t.decimal  :tax, :precision => 11, :scale => 2
      t.decimal  :shipping, :precision => 11, :scale => 2
      t.decimal  :total, :precision => 11, :scale => 2
    	t.boolean  :completed, default: false
    	t.string   :coupon_code
      t.string   :remote_ip
      t.boolean  :shipped, default: false
      t.datetime :shipped_at
      t.string   :stripe_card_token
      t.string   :currency
      t.string   :card_type
      t.string   :last4

      t.timestamps
    end

    add_index :orders, :user_id
  end
end