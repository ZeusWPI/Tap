# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  created_at          :datetime
#  updated_at          :datetime
#  remember_created_at :datetime
#  admin               :boolean          default(FALSE)
#  dagschotel_id       :integer
#  orders_count        :integer          default(0)
#  koelkast            :boolean          default(FALSE)
#  name                :string
#  private             :boolean          default(FALSE)
#  frecency            :integer          default(0), not null
#  quickpay_hidden     :boolean          default(FALSE)
#  userkey             :string
#  zauth_id            :string
#

require "faker"
require "identicon"

FactoryBot.define do
  factory :user do
    name { Faker::Internet.user_name }
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
