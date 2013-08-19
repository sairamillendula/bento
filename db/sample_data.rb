# encoding: utf-8
require 'faker'

puts "GENERATING SAMPLE DATA ..."

3.times do |x|
  print '.'
  u = x + 1
  admin = User.new(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: "admin#{u}@gmail.com",
    password: "123123",
    password_confirmation: "123123"
  )
  admin.admin = true
  admin.save!
end
puts "Created 3 admin users"


10.times do |x|
  print '.'
  c = x + 1
  client = User.new(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: "client#{c}@gmail.com",
    password: "123123",
    password_confirmation: "123123"
  )
  client.save!
  client.addresses.create!(
    full_name: Faker::Name.name,
    address1: Faker::Base.numerify("#####") + " " + Faker::Address.street_name,
    city: Faker::Address.city,
    postal_code: Faker::Base.numerify("#####"),
    country: 'CA',
    province: Country['CA'].subdivisions.map {|x| x.first}.sample
  )
  client.addresses.create!(
    full_name: Faker::Name.name,
    address1: Faker::Base.numerify("#####") + " " + Faker::Address.street_name,
    city: Faker::Address.city,
    postal_code: Faker::Base.numerify("#####"),
    country: 'CA',
    province: Country['CA'].subdivisions.map {|x| x.first}.sample
  )
end
puts "Created 10 clients"

2.times do |x|
  print '.'
  c = x + 1
  client = User.new(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: "reseller#{c}@gmail.com",
    password: "123123",
    password_confirmation: "123123"
  )
  client.build_reseller_request(
    country: "Dude",
    city: "Ottawa",
    business_name: Faker::Name.last_name,
    who_are_you: Faker::Name.last_name
  )
  client.save!
end
puts "Created 10 clients"


4.times do |x|
  print '.'
  c = x + 1
  coupon = Coupon.create!(
    code: "COUPON#{c}",
    amount: [2, 5, 10, 15, 20].sample,
    percentage: [true, false].sample,
    active: [true, false].sample
  )
end
puts "Created 4 coupons"


15.times do |x|
  print '.'
  a = x + 1
  article = Article.create!(
    title: Faker::Lorem.words(5).join(' ').titleize,
    slug: Faker::Lorem.words(5).join('-'),
    content: Faker::Lorem.paragraphs(3).join("<br/>"),
    visible: [true, false].sample,
    author_id: User.admin.map(&:id).sample
  )
end
puts "Created 15 articles"


100.times do |x|
  print '.'
  p = x + 1
  product = Product.new(
    name: Faker::Lorem.words(5).join(' ').titleize,
    slug: Faker::Lorem.words(5).join('-'),
    description: Faker::Lorem.paragraphs(3).join("<br/>"),
    visible: [true, false].sample,
    featured: [true, false].sample
  )
  product.build_master(
    sku: "00#{p}",
    price: [0.01, 3.33, 4.24, 10, 15, 20, 20.5, 25, 26.76, 66.5, 100, 104.34, 156.45, 1000, 1005.67].sample,
    reduced_price: ["", 3.33, 4.24, 10, 15, 20, 20.5, 25, 26.76, 66.5, 100, 104.34, 156.45, 1000, 1005.67].sample,
    in_stock: (0..10).to_a.sample
  )
  product.save!
end
puts "Created 100 products"


15.times do |x|
  print '.'
  r = x + 1
  review = ProductReview.create!(
    username: Faker::Name.first_name,
    rating: (1..5).to_a.sample,
    message: Faker::Lorem.paragraphs(2).join("<br/>"),
    approved: [true, false].sample,
    user_id: User.pluck(:id).uniq.sample,
    product_id: Product.pluck(:id).uniq.sample
  )
end
puts "Created 15 products reviews"

# 10.times do |x|
#   print '.'
#   p = x + 1
#   variant = ProductVariant.create!(
#     name: Faker::Lorem.words(2).join(' ').titleize,
#     price: [0.01, 3.33, 4.24, 10, 15, 20, 20.5, 25, 26.76, 66.5, 100, 104.34, 156.45, 1000, 1005.67].sample,
#     in_stock: (0..10).to_a.sample,
#     product_id: Product.pluck(:id).sample
#   )
# end
# puts "Created 15 variants"

ShippingCountry.create!(country: 'Worldwide')
puts "Added shipping country"

Collection.create!(name: 'homepage', slug: 'homepage')

Product.visibles.each do |product|
  CollectionProduct.create!(collection_id: Collection.first.id.to_i, product_id: product.id)
end
puts "Created collection for homepage"

puts "All set"
