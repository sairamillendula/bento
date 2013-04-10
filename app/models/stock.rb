class Stock < ActiveRecord::Base
	belongs_to :product
  belongs_to :product_variant

  validates_presence_of :product_id
  validates_uniqueness_of :product_id, scope: :product_variant_id, on: :create

  attr_accessible :in_stock, :product_id, :product_variant_id

  def in_stock?
    in_stock > 0
  end

end