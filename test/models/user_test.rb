# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  last_name           :string(255)
#  balance_cents       :integer          default(0), not null
#  nickname            :string(255)
#  admin               :boolean
#  koelkast            :boolean          default(FALSE)
#  dagschotel_id       :integer
#  orders_count        :integer          default(0)
#  avatar_file_name    :string(255)
#  avatar_content_type :string(255)
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  created_at          :datetime
#  updated_at          :datetime
#  encrypted_password  :string(255)      default(""), not null
#  remember_created_at :datetime
#  sign_in_count       :integer          default(0), not null
#  current_sign_in_at  :datetime
#  last_sign_in_at     :datetime
#  current_sign_in_ip  :string(255)
#  last_sign_in_ip     :string(255)
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:benji)
  end

  test "full name" do
    assert_equal @user.full_name, "Benjamin Cousaert"
  end

  test "balance behaves correctly" do
    assert_equal @user.balance_cents, 0
    assert_equal @user.balance, 0

    @user.balance = 1.3

    assert_equal @user.balance, 1.3
    assert_equal @user.balance_cents, 130
  end

  test "to_param" do
    assert_equal @user.to_param, "#{@user.id}-benji"
  end

  test "devise validatable methods" do
    assert_not @user.email_required?
    assert_not @user.email_changed?
  end
end
