class Order < ActiveRecord::Base
  belongs_to :users
  default_scope -> { order('created_at DESC') }

end
