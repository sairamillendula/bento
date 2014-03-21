json.extract! @product, :name, :current_price
json.url product_url(@product, format: :json)
json.sku @product.master.sku.to_json
json.in_stock @product.master.in_stock.to_json
json.extract! @product, :id

json.variants @product.variants do |variant|
  json.name variant.options['option1']
  json.sku variant.sku
  json.price variant.price
  json.in_stock variant.in_stock
  json.id variant.id
end

json.pictures @product.pictures do |picture|
  json.file_name picture.upload_file_name
  host_with_port = request.host_with_port
  thumbnail_path = picture.upload.url(:thumb)
  picture_thumbnail_url = "#{host_with_port}#{thumbnail_path}"
  json.thumbnail_url picture_thumbnail_url.to_s
  large_path = picture.upload.url(:large)
  picture_large_url = "#{host_with_port}#{large_path}"
  json.large_url picture_large_url.to_s
end
