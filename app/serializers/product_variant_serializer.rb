class ProductVariantSerializer < ActiveModel::Serializer
  attributes :sku, :master, :in_stock
end