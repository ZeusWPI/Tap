# == Schema Information
#
# Table name: products
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  price               :integer
#  created_at          :datetime
#  updated_at          :datetime
#  avatar_file_name    :string(255)
#  avatar_content_type :string(255)
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  category            :integer          default(0)
#  stock               :integer          default(0)
#

require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
