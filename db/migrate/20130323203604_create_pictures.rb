class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.references :picturable, :polymorphic => true
      t.has_attached_file :upload
    	t.string  :name

      t.timestamps
    end
  end
end