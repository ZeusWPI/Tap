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

  default_scope -> { order('created_at DESC') }

end
