# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  debt_cents          :integer          default("0"), not null
#  nickname            :string
#  created_at          :datetime
#  updated_at          :datetime
#  encrypted_password  :string           default(""), not null
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
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:benji)
  end

  test "full name" do
    assert_equal @user.full_name, "Benjamin Cousaert"
  end

  test "debt behaves correctly" do
    assert_equal @user.debt_cents, 0
    assert_equal @user.debt, 0

    @user.debt = 1.3

    assert_equal @user.debt, 1.3
    assert_equal @user.debt_cents, 130
  end

  test "to_param" do
    assert_equal @user.to_param, "#{@user.id}-benji"
  end

  test "devise validatable methods" do
    assert_not @user.email_required?
    assert_not @user.email_changed?
  end
end
