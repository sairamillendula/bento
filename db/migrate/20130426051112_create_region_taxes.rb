class CreateRegionTaxes < ActiveRecord::Migration
  def change
    create_table :region_taxes do |t|
      t.references :tax
      t.string :province
      t.string :name
      t.decimal :rate, precision: 4, scale: 2, default: 0

      t.timestamps
    end
    add_index :region_taxes, :tax_id
  end
end
