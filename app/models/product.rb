class Product < ActiveRecord::Base
	after_initialize :init


	def init
      self.name  ||= "FOOBAR"      
      self.sale_price ||= 0
      self.purchase_price ||= 0
      self.image_path = "/" #paperclip gem
    end
end
