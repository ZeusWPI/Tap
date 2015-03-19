# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
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

users = [
  {
    nickname:   'admin',
    avatar:     File.new('public/seeds/users/admin.jpg', 'r'),
    admin:      true
  },
  {
    nickname:   'koelkast',
    avatar:     File.new('public/seeds/users/admin.jpg', 'r'),
    koelkast:   true
  },
  {
    nickname:   'benji',
    avatar:     File.new('public/seeds/users/benji.jpg', 'r'),
    dagschotel: Product.first
  },
  {
    nickname:   'don',
    avatar:     File.new('public/seeds/users/don.jpg', 'r')
  },
  {
    nickname:   'silox',
    avatar:     File.new('public/seeds/users/silox.jpg', 'r')
  }
]

users.each do |attr|
  User.create(
    nickname: attr[:nickname],
    avatar: attr[:avatar],
    dagschotel: attr[:dagschotel],
    password: DEFAULT_PASSWORD,
    password_confirmation: DEFAULT_PASSWORD,
    admin: attr[:admin] || false,
    koelkast: attr[:koelkast] || false
  )
end

50.times do |i|
  User.create(
    nickname: "testUser#{i}",
    avatar: users[0][:avatar],
    password: DEFAULT_PASSWORD,
    password_confirmation: DEFAULT_PASSWORD
  )
end
