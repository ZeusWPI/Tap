class Order < ActiveRecord::Base
  belongs_to :users
  has_many :order_products
  has_many :products, through: :order_products

  default_scope -> { order('created_at DESC') }

end
