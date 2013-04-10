class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
    	t.string   :code
    	t.integer  :user_id
    	t.float    :subtotal
    	t.float    :tax
    	t.float    :shipping
    	t.float    :total
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