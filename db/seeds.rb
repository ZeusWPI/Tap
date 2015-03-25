# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'faker'
require 'identicon'
DEFAULT_PASSWORD = "password"

products = [
  {
    name:     'Fanta',
    price:    0.6,
    category: 'beverages',
    stock:    25,
    avatar:   File.new('public/seeds/products/fanta.jpg', 'r')
  },
  {
    name:     'Club Mate',
    price:    1.2,
    category: 'beverages',
    stock:    25,
    avatar:   File.new('public/seeds/products/club_mate.jpg', 'r')
  },
  {
    name:     'Kinder Bueno',
    price:    0.6,
    category: 'food',
    stock:    15,
    avatar:   File.new('public/seeds/products/bueno.jpg', 'r')
  }
]

products.each do |attr|
  Product.create name: attr[:name], price: attr[:price], category: attr[:category], stock: attr[:stock], avatar: attr[:avatar]
end

User.create(
  uid: "koelkast",
  password: "password",
  password_confirmation: "password",
  avatar: Identicon.data_url_for("koelkast"),
  koelkast: true
)

20.times do |i|
  name = Faker::Name.name
  User.create(
    uid: name,
    avatar: Identicon.data_url_for(name)
  )
end
