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
    name: "Twix",
    price: 0.4,
    category: "food",
    stock: 0,
    avatar: File.new('public/seeds/products/1.jpg', 'r')
  },
  {
    name: "M&M Peanuts",
    price: 0.6,
    category: "food",
    stock: 0,
    avatar: File.new('public/seeds/products/2.jpg', 'r')
  },
  {
    name: "Snickers",
    price: 0.4,
    category: "food",
    stock: 0,
    avatar: File.new('public/seeds/products/3.jpg', 'r')
  },
  {
    name: "Fanta",
    price: 0.6,
    category: "beverages",
    stock: 0,
    avatar: File.new('public/seeds/products/4.jpg', 'r')
  },
  {
    name: "Ice Tea",
    price: 0.7,
    category: "beverages",
    stock: 0,
    avatar: File.new('public/seeds/products/5.jpg', 'r')
  },
  {
    name: "Cola",
    price: 0.6,
    category: "beverages",
    stock: 0,
    avatar: File.new('public/seeds/products/6.jpg', 'r')
  },
  {
    name: "Abrikozencake",
    price: 0.4,
    category: "food",
    stock: 0,
    avatar: File.new('public/seeds/products/7.jpg', 'r')
  },
  {
    name: "Kinder Delice",
    price: 0.4,
    category: "food",
    stock: 0,
    avatar: File.new('public/seeds/products/8.jpg', 'r')
  },
  {
    name: "Kinder Bueno",
    price: 0.6,
    category: "food",
    stock: 0,
    avatar: File.new('public/seeds/products/9.jpg', 'r')
  },
  {
    name: "Arizona Ice Tea",
    price: 1.0,
    category: "beverages",
    stock: 0,
    avatar: File.new('public/seeds/products/10.png', 'r')
  },
  {
    name: "Dinosauruskoeken",
    price: 0.5,
    category: "food",
    stock: 0,
    avatar: File.new('public/seeds/products/11.jpg', 'r')
  },
  {
    name: "Chocolade - melk",
    price: 0.7,
    category: "food",
    stock: 0,
    avatar: File.new('public/seeds/products/12.jpg', 'r')
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
