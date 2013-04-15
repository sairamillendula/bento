class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string  :title
      t.string  :slug
      t.boolean :visible, default: true
      t.text    :content
      t.integer :author_id

      t.timestamps
    end
    add_index :articles, :slug
  end
end