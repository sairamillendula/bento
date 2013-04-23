class CreateProductReviews < ActiveRecord::Migration
  def change
    create_table :product_reviews do |t|
      t.text    :message
      t.integer :rating, default: 5
      t.string  :username
      t.integer :user_id
      t.integer :product_id
      t.boolean :approved, default: true

      t.timestamps
    end
  end
end