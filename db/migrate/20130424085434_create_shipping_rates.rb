class CreateShippingRates < ActiveRecord::Migration
  def change
    create_table :shipping_rates do |t|
      t.references :shipping_country
      t.string :name
      t.string :criteria, default: 'price-based'
      t.decimal :min_criteria, precision: 6, scale: 2
      t.decimal :max_criteria, precision: 6, scale: 2
      t.decimal :price, precision: 11, scale: 2

      t.timestamps
    end
    add_index :shipping_rates, :shipping_country_id
  end
end
