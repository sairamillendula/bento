# encoding: utf-8
require 'faker'

Setting.create!(key: "twitter", value: "twitter_user")
Setting.create!(key: "facebook", value: "facebook_user")

Page.create!(name: 'Contact', slug: 'contact', content: Faker::Lorem.paragraphs(3).join("<br/>"), klass: 'standard')
Page.create!(name: 'About', slug: 'about', content: Faker::Lorem.paragraphs(4).join("<br/>"), klass: 'standard')
Page.create!(name: 'Press', slug: 'media', content: Faker::Lorem.paragraphs(4).join("<br/>"), klass: 'standard')
Page.create!(name: 'Terms & Conditions', slug: 'terms', content: Faker::Lorem.paragraphs(4).join("<br/>"), klass: 'standard')
Page.create!(name: 'FAQ', slug: 'faq', content: Faker::Lorem.paragraphs(4).join("<br/>"), klass: 'faq')