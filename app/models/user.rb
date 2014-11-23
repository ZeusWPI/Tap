class User < ActiveRecord::Base
  has_many :orders
  before_save :init



  def init
    self.balance ||= 0
  end


  has_secure_password
end
