class User < ActiveRecord::Base
	has_many :orders, dependent: :destroy
	after_initialize :init

	validates :name, presence: true, length: { maximum: 50 },
					 uniqueness: true

	def init
      self.marks  ||= 0         
      self.role ||= "user"
  end

  def feed
    # This is preliminary. See "Following users" for the full implementation.
    Order.where("user_id = ?", id)
  end

end
