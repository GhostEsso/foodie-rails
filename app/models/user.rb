class User < ApplicationRecord
  has_secure_password
  
  has_one :apartment
  has_one :building, through: :apartment
  has_many :dishes, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :received_bookings, through: :dishes, source: :bookings
  has_many :notifications, dependent: :destroy

  validates :email, presence: true, uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :full_name, presence: true
  validates :password, presence: true, length: { minimum: 6 }, on: :create

  def unread_notifications_count
    notifications.unread.count
  end

  def mark_notifications_as_read!
    notifications.unread.update_all(read_at: Time.current)
  end
end
