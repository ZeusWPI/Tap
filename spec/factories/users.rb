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
#  avatar_file_name    :string
#  avatar_content_type :string
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  orders_count        :integer          default(0)
#  koelkast            :boolean          default(FALSE)
#  name                :string
#  private             :boolean          default(FALSE)
#  frecency            :integer          default(0), not null
#

require 'faker'
require 'identicon'

FactoryGirl.define do
  factory :user do
    name    { Faker::Internet.user_name }
    avatar  { Identicon.data_url_for name }
    private { false }

    factory :admin do
      admin true
    end
  end
end
