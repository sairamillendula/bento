class ProductOption < ActiveRecord::Base
  belongs_to :product
  attr_accessible :name, :product, :values

  validates_uniqueness_of :name, :scope => :product_id
  validates_presence_of :name
end
