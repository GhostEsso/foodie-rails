class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :booking, optional: true

  validates :message, presence: true
  validates :notification_type, presence: true, 
            inclusion: { in: %w[new_booking booking_approved booking_rejected] }

  scope :unread, -> { where(read_at: nil) }
end 