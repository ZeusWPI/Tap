require 'test_helper'

class OrderIntegrationTest < ActionDispatch::IntegrationTest
  test 'orders are saved for the right user' do
    allproducts = [products(:fanta), products(:cola), products(:mate), products(:bueno)]

    allproducts.each do |product|
      product.avatar = File.new('public/seeds/products/fanta.jpg', 'r')
      product.save
    end

    sign_in users(:koelkast)
    visit new_user_order_path(users(:benji))

    assert page.has_content? 'Order for benji'

    assert_difference "User.find(users(:benji).id).balance_cents", -240 do
      fill_in 'order_order_items_attributes_2_count', with: 2
      click_button "Order!"
    end
  end
end
