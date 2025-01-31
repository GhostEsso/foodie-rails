class ConversationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation, only: [:show]

  def index
    @conversations = current_user.conversations
                               .includes(:sender, :receiver, :dish, messages: :user)
                               .order(updated_at: :desc)
  end

  def show
    @messages = @conversation.messages.includes(:user).order(created_at: :asc)
    @conversation.mark_as_read!(current_user)
  end

  def create
    dish = Dish.find(params[:dish_id])
    @conversation = Conversation.find_or_create_by(
      dish: dish,
      sender: current_user,
      receiver: dish.user
    )
    redirect_to conversation_path(@conversation)
  end

  private

  def set_conversation
    @conversation = current_user.conversations.find(params[:id])
  end

  def conversation_params
    params.require(:conversation).permit(:dish_id, :receiver_id)
  end
end 