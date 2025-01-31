class Apartment < ApplicationRecord
  belongs_to :building
  belongs_to :user

  validates :number, presence: true
  validates :number, uniqueness: { scope: :building_id }
end
