# == Schema Information
#
# Table name: products
#
#  id                  :integer          not null, primary key
#  name                :string           not null
#  price_cents         :integer          default("0"), not null
#  created_at          :datetime
#  updated_at          :datetime
#  avatar_file_name    :string
#  avatar_content_type :string
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  category            :integer          default("0")
#  stock               :integer          default("0"), not null
#  calories            :integer
#  deleted             :boolean          default("f")
#

require 'faker'
require 'identicon'

FactoryGirl.define do
  factory :product do
    name { Faker::Name.name }
    price_cents { rand 120 }
    stock { 30 + rand(30) }
    calories { rand 20 }
    avatar { Identicon.data_url_for name }

    factory :invalid_product do
      name nil
    end
  end
end
