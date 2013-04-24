class CreateShippingCountries < ActiveRecord::Migration
  def change
    create_table :shipping_countries do |t|
      t.string :country

      t.timestamps
    end
  end
end
