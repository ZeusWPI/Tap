# == Schema Information
#
# Table name: products
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  purchase_price :integer
#  sale_price     :integer
#  img_path       :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
