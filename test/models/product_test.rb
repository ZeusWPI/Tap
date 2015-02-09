# == Schema Information
#
# Table name: products
#
#  id                  :integer          not null, primary key
#  name                :string(255)      not null
#  price_cents         :integer          default(0), not null
#  category            :integer          default(0)
#  stock               :integer          default(0), not null
#  avatar_file_name    :string(255)
#  avatar_content_type :string(255)
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  created_at          :datetime
#  updated_at          :datetime
#

require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
