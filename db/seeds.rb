# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


User.create!(name:  "Example User", marks: 5)

99.times do |n|
  name  = Faker::Name.name
  marks = n+1
  User.create!(name:  name,
               marks: marks)
end

users = User.order(:created_at).take(6)
50.times do
  products = Faker::Lorem.sentence(5)
  users.each { |user| user.orders.create!(products: products) }
end