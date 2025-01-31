class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :dish

  validates :portions, presence: true, 
            numericality: { only_integer: true, greater_than: 0 }
  validates :status, presence: true, 
            inclusion: { in: %w[pending approved rejected] }
  validate :enough_portions_available

  private

  def enough_portions_available
    return unless dish && portions

    available = dish.portions - dish.bookings.where(status: ['pending', 'approved'])
                                           .where.not(id: id)
                                           .sum(:portions)

    if portions > available
      errors.add(:portions, "n'est pas disponible en quantité suffisante (#{available} disponible)")
    end
  end
end
