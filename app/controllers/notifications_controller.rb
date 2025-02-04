class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def mark_as_read
    current_user.mark_notifications_as_read!
    head :ok
  end
end
