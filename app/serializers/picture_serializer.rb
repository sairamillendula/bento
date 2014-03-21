class PictureSerializer < ActiveModel::Serializer
  attributes :name, :thumbnail_url, :url

  def url
    "https://jolibento.com#{object.upload.url(:original)}"
  end

  def thumbnail_url
    "https://jolibento.com#{object.upload.url(:thumbnail)}"
  end

end