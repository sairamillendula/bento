# encoding: utf-8
require 'faker'

Page.create!(name: 'Contact', slug: 'contact', content: Faker::Lorem.paragraphs(3).join("<br/>"), klass: 'standard')
Page.create!(name: 'About', slug: 'about', content: Faker::Lorem.paragraphs(4).join("<br/>"), klass: 'standard')
Page.create!(name: 'Press', slug: 'media', content: Faker::Lorem.paragraphs(4).join("<br/>"), klass: 'standard')
Page.create!(name: 'Terms & Conditions', slug: 'terms', content: Faker::Lorem.paragraphs(4).join("<br/>"), klass: 'standard')
Page.create!(name: 'FAQ', slug: 'faq', content: Faker::Lorem.paragraphs(4).join("<br/>"), klass: 'faq')
puts "creating default pages..."

ShippingCountry.create!(country: 'WORLDWIDE')
puts "Created shipping country: WORLDWIDE"

Setting.create!(
	abandoned_carts_reminder: "3"
)
puts "Created default settings..."

Collection.create!(name: 'Couverts bento', slug: 'couvert')
Collection.create!(name: 'Sac bento (Furoshiki)', slug: 'sac')
Collection.create!(name: 'Serviette de table lunch box', slug: 'serviette-de-table')
Collection.create!(name: 'Kit lunch box bento', slug: 'kit')
Collection.create!(name: 'Boite bento pour enfant', slug: 'enfant')
Collection.create!(name: 'Boite bento japonaise', slug: 'traditionnel')
Collection.create!(name: 'Boite bento moderne', slug: 'moderne')
Collection.create!(name: 'revendeur', slug: 'revendeur', visible: false)

puts "Created default collections..."