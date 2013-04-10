class CreateResellerRequests < ActiveRecord::Migration
  def change
    create_table :reseller_requests do |t|
      t.integer :user_id
      t.boolean :approved, default: false
      t.string  :business_name
      t.string  :country
      t.string  :city
      t.text    :who_are_you

      t.timestamps
    end
  end
end