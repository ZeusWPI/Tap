class Order < ActiveRecord::Base
  belongs_to :user

  validates :products, presence: true, length: { maximum: 140 }
end
