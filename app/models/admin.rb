class Admin < ActiveRecord::Base
  devise :database_authenticatable, :trackable
end
