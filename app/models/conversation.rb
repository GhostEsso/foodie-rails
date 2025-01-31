class Conversation < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'
  belongs_to :dish
  has_many :messages, dependent: :destroy

  validates :sender_id, uniqueness: { scope: [:receiver_id, :dish_id] }

  def unread_messages_count(user)
    messages.where.not(user: user).where(read_at: nil).count
  end

  def mark_as_read!(user)
    messages.where.not(user: user).update_all(read_at: Time.current)
  end

  def other_user(current_user)
    current_user == sender ? receiver : sender
  end
end
