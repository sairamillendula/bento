class CreateCollections < ActiveRecord::Migration
  def change
    create_table :collections do |t|
      t.string  :name
      t.string  :slug
      t.boolean :visible, default: true
      t.text    :description
      t.text    :meta_tag

      t.timestamps
    end
  end
end