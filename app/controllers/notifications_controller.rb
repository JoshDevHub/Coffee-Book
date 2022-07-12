class NotificationsController < ApplicationController
  before_action :user_param

  def index
    @notifications = @user.notifications.includes(:friendship)
  end

  private

  def user_param
    @user = User.find(params[:user_id])
  end
end
