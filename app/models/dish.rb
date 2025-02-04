class Dish < ApplicationRecord
  belongs_to :user
  has_one :apartment, through: :user
  has_many :bookings, dependent: :destroy
  has_many :conversations, dependent: :destroy
  has_many_attached :photos

  validates :name, presence: true, length: { minimum: 3, maximum: 100 }
  validates :description, presence: true, length: { minimum: 10, maximum: 1000 }
  validates :portions, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :photos, content_type: [ "image/png", "image/jpeg", "image/gif" ],
            size: { less_than: 5.megabytes },
            limit: { max: 3, message: "maximum 3 photos par plat" },
            if: :photos_attached?

  def available_portions
    portions - bookings.where(status: "approved").sum(:portions)
  end

  def pending_portions
    bookings.where(status: "pending").sum(:portions)
  end

  def total_available_portions
    portions - pending_portions
  end

  private

  def photos_attached?
    photos.attached?
  end
end
