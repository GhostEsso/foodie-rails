class Building < ApplicationRecord
  has_many :apartments
  has_many :users, through: :apartments

  validates :name, presence: true
  validates :address, presence: true
end
