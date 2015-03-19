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
#

require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  test "price behaves correctly" do
    p = products(:fanta)

    assert_equal p.price_cents, 60
    assert_equal p.price, 0.6

    p.price = 1.3

    assert_equal p.price, 1.3
    assert_equal p.price_cents, 130
  end
end
