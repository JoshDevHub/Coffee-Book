class NotificationsController < ApplicationController
  before_action :user_read_notifications, only: :index

  # GET "/notifications"
  def index
    @notifications = current_user.notifications.most_recent
  end

  private

  def user_read_notifications
    current_user.read_notifications
  end
end
