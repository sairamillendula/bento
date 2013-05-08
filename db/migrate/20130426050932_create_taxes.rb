class CreateTaxes < ActiveRecord::Migration
  def change
    create_table :taxes do |t|
      t.references :shipping_country
      t.string     :name
      t.decimal    :rate, precision: 4, scale: 2, default: 0
      t.integer    :region_taxes_count, default: 0

      t.timestamps
    end
    add_index :taxes, :shipping_country_id
  end
end