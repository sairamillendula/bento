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
    in_stock: (0..10).to_a.sample,
    cost_price: 1
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
    user_id: User.all.map(&:id).uniq.sample,
    product_id: Product.pluck(:id).uniq.sample
  )
end
puts "Created 15 products reviews"


p = Product.first
p.options.create!(name: 'Color', values: 'blue, red, green,')
p.options.create!(name: 'Size', values: 'S, M, L,')
p.variants.create!(option1: "blue", option2: "S", price: 15, reduced_price: 10, in_stock: 45, sku: "P0001a")
p.variants.create!(option1: "blue", option2: "M", price: 15, reduced_price: 10, in_stock: 0, sku: "P0001b")
p.variants.create!(option1: "blue", option2: "L", price: 15, reduced_price: 10, in_stock: 105, sku: "P0001c")
p.variants.create!(option1: "red", option2: "S", price: 15, reduced_price: 10, in_stock: 105, sku: "P0001d")
p.variants.create!(option1: "green", option2: "S", price: 15, reduced_price: 10, in_stock: 10, sku: "P0001e")
p.update_attributes(visible: true)

puts "Created options and variants for product #1"


c = ShippingCountry.create!(country: 'FR')
c.rates.create!(min_criteria: 0, max_criteria: 100, price: 8, name: 'Standard (5 days)')
c.tax.name = 'TVA'
c.tax.rate = 19.6
c.tax.save!
puts "Created shipping country: France"

c = ShippingCountry.create!(country: 'CA')
c.rates.create!(min_criteria: 0, max_criteria: 100, price: 8, name: 'Standard (5 days)')
c.tax.name = 'TVH'
c.tax.rate = 13
c.tax.save!
t = 
t = c.tax.region_taxes.where(province: 'AB').first
t.update_attributes(name: 'HST', rate: '5')
t = c.tax.region_taxes.where(province: 'QC').first
t.update_attributes(name: 'TVH', rate: '9.975')
t = c.tax.region_taxes.where(province: 'ON').first
t.update_attributes(name: 'HST', rate: '13')
puts "Created shipping country: Canada"


Collection.create!(name: 'Top Sellers', slug: 'top-sellers')
Collection.create!(name: 'On Sale', slug: 'on-sale')
Collection.create!(name: 'homepage', slug: 'homepage')
puts "Created collection for homepage"

Product.visibles.each do |product|
  CollectionProduct.create!(collection_id: Collection.first.id.to_i, product_id: product.id)
end

puts "All set"
