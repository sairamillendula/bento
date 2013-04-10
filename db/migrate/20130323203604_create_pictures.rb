class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
    	t.integer :picturable_id
    	t.string  :picturable_type
    	t.string  :name

      t.timestamps
    end
  end
end