# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  admin               :boolean          default(FALSE)
#  frecency            :integer          default(0), not null
#  koelkast            :boolean          default(FALSE)
#  name                :string
#  orders_count        :integer          default(0)
#  private             :boolean          default(FALSE)
#  quickpay_hidden     :boolean          default(FALSE)
#  remember_created_at :datetime
#  userkey             :string
#  created_at          :datetime
#  updated_at          :datetime
#  dagschotel_id       :integer
#  zauth_id            :text             not null
#
# Indexes
#
#  index_users_on_koelkast      (koelkast)
#  index_users_on_orders_count  (orders_count)
#  index_users_on_zauth_id      (zauth_id) UNIQUE
#
# Foreign Keys
#
#  dagschotel_id  (dagschotel_id => products.id)
#

require "faker"
require "identicon"

FactoryBot.define do
  factory :user do
    name { Faker::Internet.user_name.gsub(/[^a-zA-Z]/, "") }
    zauth_id { Faker::String.random }
    private { false }

    factory :admin do
      admin { true }
    end

    factory :koelkast do
      koelkast { true }
      name { "koelkast" }
    end
  end
end
