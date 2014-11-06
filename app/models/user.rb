class User < ActiveRecord::Base
	validates :name, presence: true, length: { maximum: 50 }
end
