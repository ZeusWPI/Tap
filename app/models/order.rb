# == Schema Information
#
# Table name: orders
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  cost       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Order < ActiveRecord::Base
  belongs_to :user

  has_many :order_products
  has_many :products, -> { includes :order_product }, { through: :order_products} do
    def << (product)
      if proxy_association.owner.products.include?(product)
        proxy_association.owner.order_products.find_by(product: product).increment!(:count, 1)
      else
        super
      end
    end
  end

  validates :user, presence: true

  accepts_nested_attributes_for :order_products

  default_scope -> { order('created_at DESC') }

end
