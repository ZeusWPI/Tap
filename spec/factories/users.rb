# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  created_at          :datetime
#  updated_at          :datetime
#  remember_created_at :datetime
#  admin               :boolean
#  dagschotel_id       :integer
#  avatar_file_name    :string
#  avatar_content_type :string
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  orders_count        :integer          default("0")
#  koelkast            :boolean          default("f")
#  name                :string
#  encrypted_password  :string           default(""), not null
#  private             :boolean          default("f")
#

require 'faker'
require 'identicon'

FactoryGirl.define do
  factory :user do
    name    { Faker::Name.name }
    avatar  { Identicon.data_url_for name }
    private { false }

    factory :admin do
      admin true
    end

    factory :koelkast do
      koelkast true
      name "koelkast"
    end
  end
end
