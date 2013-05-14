class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string  :full_name
      t.string  :address1
      t.string  :address2
      t.string  :city
      t.string  :province
      t.string  :postal_code
      t.string  :country
      t.string  :type
      t.integer :addressable_id
      t.string  :addressable_type

      t.timestamps
    end
    
    add_index :addresses, :type
    add_index :addresses, :addressable_id
    add_index :addresses, :addressable_type
  end
end