class NotificationsController < ApplicationController
  def index
    @notifications = Notification.where(user_id: params[:user_id])
  end
end
