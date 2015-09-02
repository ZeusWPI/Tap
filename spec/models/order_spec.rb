# == Schema Information
#
# Table name: orders
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  price_cents :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  cancelled   :boolean          default("f")
#

describe Order do
  before :each do
    @order = create :order
  end

  it 'has a valid factory' do
    expect(@order).to be_valid
  end
end
