class AddIndexToPicture < ActiveRecord::Migration
  def change
    add_index :pictures, [:picturable_id, :picturable_type], :name => "pictures_picturable_index"
    add_index :pictures, [:position], :name => "pictures_position_index"
  end
end
