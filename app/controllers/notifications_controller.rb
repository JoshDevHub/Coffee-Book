class NotificationsController < ApplicationController
  before_action :user_param
  before_action :user_read_notifications, only: :index

  def index
    @notifications = @user.notifications.includes(:friendship)
  end

  private

  def user_param
    @user = User.find(params[:user_id])
  end

  def user_read_notifications
    current_user.read_notifications
  end
end
