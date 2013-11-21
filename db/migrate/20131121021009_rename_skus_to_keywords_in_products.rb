class RenameSkusToKeywordsInProducts < ActiveRecord::Migration
  def change
    rename_column :products, :skus, :keywords
  end
end
