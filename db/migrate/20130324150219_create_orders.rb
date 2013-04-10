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
    	t.string   :payment_type
    	t.string   :coupon_code
      t.string   :remote_ip
      t.boolean  :shipped, default: false
      t.datetime :shipped_at

      t.timestamps
    end

    add_index :orders, :user_id
  end
end