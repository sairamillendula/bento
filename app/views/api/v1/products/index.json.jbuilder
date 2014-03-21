json.array!(@products) do |product|
  json.extract! product, :id, :name, :current_price
  json.url product_url(product, format: :json)
  json.sku product.master.sku.to_json
  json.in_stock product.master.in_stock.to_json

  json.variants product.variants do |variant|
    json.name variant.options['option1']
    json.sku variant.sku
    json.in_stock variant.in_stock
    end
  json.pictures product.pictures do |picture|
    json.name picture.upload_file_name
    scheme = request.protocol
    host = request.host_with_port
    path = picture.upload.url(:thumb)
    picture_url = URI::Generic::new scheme, nil, host, nil, nil, path, nil, nil, nil
    json.url picture_url.to_s
    end
end
