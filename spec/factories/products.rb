# frozen_string_literal: true

# == Schema Information
#
# Table name: products
#
#  id                  :integer          not null, primary key
#  avatar_content_type :string
#  avatar_file_name    :string
#  avatar_file_size    :bigint
#  avatar_updated_at   :datetime
#  calories            :integer
#  category            :integer          default(0)
#  deleted             :boolean          default(FALSE)
#  name                :string           not null
#  price_cents         :integer          default(0), not null
#  stock               :integer          default(0), not null
#  created_at          :datetime
#  updated_at          :datetime
#

require "faker"
require "identicon"

FactoryBot.define do
  factory :product do
    name        { Faker::Name.name }
    price_cents { rand(1..120) }
    price       { price_cents / 100.0 }
    stock       { rand(30..59) }
    calories    { rand 20 }
    avatar      { Identicon.data_url_for name }

    factory :invalid_product do
      name { nil }
    end
  end
end
