class ProductSerializer < ActiveModel::Serializer
  attributes :name, :url, :current_price, :on_sale?
  has_one :master, embed: :objects
  has_many :variants, embed: :objects
  has_one :main_picture, embed: :objects

  def url
    product_url(object)
  end

end
