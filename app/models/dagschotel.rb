class Dagschotel < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :user, presence: true
  validates :product, presence: true, uniqueness: { scope: :user }
end
