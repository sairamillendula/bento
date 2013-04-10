class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string  :name
      t.string  :slug
      t.string  :klass
      t.text    :content
      t.boolean :public, default: true

      t.timestamps
    end

    add_index :pages, :slug
  end
end