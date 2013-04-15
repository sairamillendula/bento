class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string  :name
      t.string  :slug
      t.boolean :visible, default: true
      t.string  :klass
      t.text    :content
      t.text    :meta_tag

      t.timestamps
    end

    add_index :pages, :slug
  end
end