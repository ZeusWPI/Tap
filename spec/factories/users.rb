# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  created_at          :datetime
#  updated_at          :datetime
#  remember_created_at :datetime
#  sign_in_count       :integer          default("0"), not null
#  current_sign_in_at  :datetime
#  last_sign_in_at     :datetime
#  current_sign_in_ip  :string
#  last_sign_in_ip     :string
#  admin               :boolean
#  dagschotel_id       :integer
#  avatar_file_name    :string
#  avatar_content_type :string
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  orders_count        :integer          default("0")
#  koelkast            :boolean          default("f")
#  provider            :string
#  uid                 :string
#  encrypted_password  :string           default(""), not null
#  private             :boolean          default("f")
#

require 'faker'
require 'identicon'

FactoryGirl.define do
  factory :user do
    uid    { Faker::Name.name }
    avatar { Identicon.data_url_for uid }

    factory :admin do
      admin true
    end

    factory :koelkast do
      koelkast true
    end
  end
end
