class User < ActiveRecord::Base
	after_initialize :init

	validates :name, presence: true, length: { maximum: 50 },
					 uniqueness: true

	def init
      self.marks  ||= 0         
      self.role ||= "user"
    end


end
