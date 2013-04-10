class SorceryCore < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string  :email,            default: nil, null: false
      t.string  :first_name
      t.string  :last_name
      t.boolean :active,           default: true
      t.boolean :admin,            default: false
      t.boolean :reseller,         default: false
      t.string  :localization,     default: "en"
      t.string  :crypted_password, default: nil
      t.string  :salt,             default: nil

      t.timestamps
    end
  end
end