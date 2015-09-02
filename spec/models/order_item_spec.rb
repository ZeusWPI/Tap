describe OrderItem do
  before :each do
    @order_item = create :order_item
  end

  it 'has a valid factory' do
    expect(@order_item).to be_valid
  end
end
