class Dish < ApplicationRecord
  belongs_to :user
  has_one :apartment, through: :user
  has_many :bookings, dependent: :destroy

  validates :name, presence: true, length: { minimum: 3, maximum: 100 }
  validates :description, presence: true, length: { minimum: 10, maximum: 1000 }
  validates :portions, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def available_portions
    portions - bookings.where(status: 'approved').sum(:portions)
  end

  def pending_portions
    bookings.where(status: 'pending').sum(:portions)
  end

  def total_available_portions
    portions - (bookings.where(status: ['pending', 'approved']).sum(:portions))
  end
end
