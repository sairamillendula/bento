class CreateMetaTags < ActiveRecord::Migration
  def change
    create_table :meta_tags do |t|
      t.string  :title
      t.text    :description
      t.integer :meta_taggable_id
      t.string  :meta_taggable_type

      t.timestamps
    end
  end
end