class Order < ActiveRecord::Base
  belongs_to :user
  
  default_scope -> { order('created_at DESC') }
  validates :products, presence: true, length: { maximum: 140 }
end
