# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create! name:  "Mats",
             nickname: "Basho",
             last_name: "Myncke",
             password:              "banaan12",
             password_confirmation: "banaan12"

99.times do |n|
  name  = Faker::Name.first_name
  nickname = Faker::Name.title
  last_name = Faker::Name.last_name
  password = "password"

  User.create! name: name,
               nickname: nickname,
               last_name: last_name,
               password: password,
               password_confirmation: password
end
