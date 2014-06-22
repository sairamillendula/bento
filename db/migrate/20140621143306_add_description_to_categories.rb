class AddDescriptionToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :description, :text
    add_column :categories, :meta_tag, :text
  end
end
