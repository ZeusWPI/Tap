# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if Rails.env.development?
  require 'faker'
  require 'tqdm'

  puts "** Seeding database..."

  puts "** Creating 50 users..."

  # Generate random users
  users = 50.times.with_progress.map do |i|
    name = Faker::Internet.unique.username(separators: %w(- _))

    User.create!(
      name: name,
      private: false,
    )
  end

  puts "** Creating 100 products..."

  # Generate random products
  products = 100.times.with_progress.map do |i|
    name = Faker::Commerce.unique.product_name

    Product.create!(
      name: name,
      price_cents: Faker::Number.between(from: 10, to: 1000),
      stock: Faker::Number.between(from: 10, to: 200),
      calories: Faker::Number.between(from: 10, to: 1000),
      category: ['food', 'beverages', 'other'].sample,
      avatar: Paperclip.io_adapters.for(Identicon.data_url_for(name))
    )
  end

  puts "** Done!"
end
