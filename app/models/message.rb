class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :user

  validates :content, presence: true

  scope :unread, -> { where(read_at: nil) }
  scope :ordered, -> { order(created_at: :asc) }

  after_create_commit :broadcast_message

  private

  def broadcast_message
    broadcast_append_to conversation,
                       target: "conversation_#{conversation.id}_messages",
                       partial: "messages/message",
                       locals: { message: self }
  end
end
