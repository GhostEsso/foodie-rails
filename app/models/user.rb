class User < ApplicationRecord
  has_secure_password
  has_one_attached :avatar
  
  has_one :apartment
  has_one :building, through: :apartment
  has_many :dishes, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :received_bookings, through: :dishes, source: :bookings
  has_many :notifications, dependent: :destroy
  has_many :sent_conversations, class_name: 'Conversation', foreign_key: 'sender_id'
  has_many :received_conversations, class_name: 'Conversation', foreign_key: 'receiver_id'
  has_many :messages

  validates :email, presence: true, uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :full_name, presence: true
  validates :password, presence: true, length: { minimum: 6 }, on: :create
  
  # Validation de l'avatar
  validate :avatar_validation, if: :avatar_attached?

  def unread_notifications_count
    notifications.unread.count
  end

  def mark_notifications_as_read!
    notifications.unread.update_all(read_at: Time.current)
  end

  def unread_messages_count
    Message.joins(:conversation)
          .where('(conversations.sender_id = :user_id OR conversations.receiver_id = :user_id) AND messages.user_id != :user_id AND messages.read_at IS NULL', user_id: id)
          .count
  end

  def conversations
    Conversation.where('sender_id = :id OR receiver_id = :id', id: id)
  end

  private

  def avatar_attached?
    avatar.attached?
  end

  def avatar_validation
    if avatar.blob.byte_size > 5.megabytes
      errors.add(:avatar, 'doit être inférieur à 5 Mo')
    end

    acceptable_types = ['image/png', 'image/jpeg', 'image/gif']
    unless acceptable_types.include?(avatar.blob.content_type)
      errors.add(:avatar, 'doit être au format PNG, JPEG ou GIF')
    end
  end
end
