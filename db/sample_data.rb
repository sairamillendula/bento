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
  client_build_reseller_request(
    country: "Dude",
    city: "Ottawa",
    buisness_name: Faker::Name.last_name,
    who_are_you: Faker::Name.last_name,
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
    public: [true, false].sample,
    author_id: User.admin.map(&:id).sample
  )
end
puts "Created 15 articles"


15.times do |x|
  print '.'
  p = x + 1
  product = Product.create!(
    name: Faker::Lorem.words(5).join(' ').titleize,
    slug: Faker::Lorem.words(5).join('-'),
    description: Faker::Lorem.paragraphs(3).join("<br/>"),
    public: [true, false].sample,
    back_ordered: [true, false].sample,
    featured: [true, false].sample,
    price: [0.01, 3.33, 4.24, 10, 15, 20, 20.5, 25, 26.76, 66.5, 100, 104.34, 156.45, 1000, 1005.67].sample,
    sale_price: ["", 3.33, 4.24, 10, 15, 20, 20.5, 25, 26.76, 66.5, 100, 104.34, 156.45, 1000, 1005.67].sample
  )
end
puts "Created 15 products"

puts "All set"