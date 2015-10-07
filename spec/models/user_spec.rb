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

describe User do
  before :each do
    @user = create :user
  end

  it 'has a valid factory' do
    expect(@user).to be_valid
  end

  ############
  #  FIELDS  #
  ############

  describe 'fields' do
    describe 'avatar' do
      it 'should be present' do
        @user.avatar = nil
        expect(@user).to_not be_valid
      end
    end

    describe 'orders_count' do
      it 'should automatically cache the number of orders' do
        expect{ create :order, user: @user }.to change{ @user.reload.orders_count }.by(1)
      end
    end
  end
end
