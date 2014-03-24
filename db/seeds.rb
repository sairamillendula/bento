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
puts "Created defaut settings..."