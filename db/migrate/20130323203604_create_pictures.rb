class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.references :picturable, :polymorphic => true
      t.has_attached_file :upload
      t.integer :position      

      t.timestamps
    end
  end
end