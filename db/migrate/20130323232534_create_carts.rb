class CreateCarts < ActiveRecord::Migration
  def change
    create_table :carts do |t|
      t.decimal  :subtotal, :precision => 11, :scale => 2
      t.decimal  :tax, :precision => 11, :scale => 2
      t.decimal  :shipping, :precision => 11, :scale => 2
      t.decimal  :total, :precision => 11, :scale => 2
      
      t.timestamps
    end
  end
end