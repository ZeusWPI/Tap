require 'test_helper'

class OrderIntegrationTest < ActionDispatch::IntegrationTest
  def setup
    Product.all.each do |product|
      product.avatar = File.new('public/seeds/products/fanta.jpg', 'r')
      product.save
    end

    sign_in users(:koelkast)
  end

  test 'orders are saved for the right user' do
    visit new_user_order_path(users(:benji))

    assert page.has_content? 'Order for benji'

    assert_difference "User.find(users(:benji).id).debt_cents", 240 do
      fill_in 'order_order_items_attributes_2_count', with: 2
      click_button "Order!"
    end
  end

  test 'quickpay' do
    assert_difference "User.find(users(:benji).id).debt_cents", User.find(users(:benji).id).dagschotel.price_cents do
      visit user_quickpay_path(users(:benji))
      assert page.has_content? 'Success!'
    end
  end

  test 'cancelling quickpay' do
    visit user_quickpay_path(users(:benji))

    assert_difference "User.find(users(:benji).id).debt_cents", -User.find(users(:benji).id).dagschotel.price_cents do
      click_link 'Undo'
      assert page.has_content? 'Success!'
    end
  end
end
