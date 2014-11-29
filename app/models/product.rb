class Product < ActiveRecord::Base
  has_one :order_product
end
