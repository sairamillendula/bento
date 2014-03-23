class AddOptionsToSetting < ActiveRecord::Migration
  def change
    add_column :settings, :options, :hstore
    remove_column :settings, :var
    remove_column :settings, :value
    remove_column :settings, :thing_id
    remove_column :settings, :thing_type
  end
end
