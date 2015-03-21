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
    uid:   'admin',
    avatar:     File.new('public/seeds/users/admin.jpg', 'r'),
    admin:      true
  },
  {
    uid:   'koelkast',
    avatar:     File.new('public/seeds/users/admin.jpg', 'r'),
    koelkast:   true
  },
  {
    uid:   'benji',
    # avatar:     File.new('public/seeds/users/benji.jpg', 'r'),
    dagschotel: Product.first,
  },
  {
    uid:   'don',
    avatar:     File.new('public/seeds/users/don.jpg', 'r')
  },
  {
    uid:   'silox',
    avatar:     File.new('public/seeds/users/silox.jpg', 'r')
  }
]

users.each do |attr|
  User.create(
    uid: attr[:uid],
    provider: attr[:provider],
    avatar: attr[:avatar],
    dagschotel: attr[:dagschotel],
    admin: attr[:admin] || false,
    koelkast: attr[:koelkast] || false
  )
end

# 50.times do |i|
  # User.create(
    # uid: "testUser#{i}",
    # avatar: users[0][:avatar],
  # )
# end
