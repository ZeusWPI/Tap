# == Schema Information
#
# Table name: orders
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  transaction_id :integer
#  product_id     :integer
#

describe OrdersController, type: :controller do
  # before :each do
    # @user = create :user
    # sign_in @user
  # end

  # #######
  # # NEW #
  # #######

  # describe 'GET new' do

  # end

  # ##########
  # # CREATE #
  # ##########

  # describe 'POST create' do

  # end

  # ###########
  # # DESTROY #
  # ###########

  # describe 'DELETE destroy' do

  # end
end
