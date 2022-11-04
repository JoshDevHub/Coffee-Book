class FriendshipsController < ApplicationController
  before_action :find_received_request_for_current_user, only: :confirm_request

  # GET "/users/:username/friends"
  def index
    @user = User.find_by!(username: params[:username])
    @friends = @user.friends_with_avatar
    find_pending_requests if current_user == @user
    @current_user_friendships = Friendship.for(current_user)
  end

  # POST "/users/:id/friendships"
  def create
    @friendship = current_user.sent_friend_requests.build(friendship_params)
    if @friendship.save
      flash[:success] = "Friend Request Sent"
      @friendship.notify(@friendship.sender, @friendship.receiver)
    end

    redirect_back fallback_location: root_path
  end

  # DELETE "/friendships"
  def destroy
    @friendship = Friendship.find(params[:id])
    @friendship.destroy
    flash[:notice] = "Request denied"

    redirect_to user_friends_path(current_user), status: :see_other
  end

  # PATCH "/friendships/:id/confirm_request"
  def confirm_request
    @friendship.confirm
    @friendship.notify(@friendship.receiver, @friendship.sender)
    flash[:notice] = "Friend Added"
    redirect_back fallback_location: root_path
  end

  private

  def friendship_params
    params.require(:friendship).permit(:sender, :receiver_id)
  end

  def find_received_request_for_current_user
    @friendship = current_user.received_friend_requests.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Unauthorized Access"
    redirect_to root_path
  end

  def find_pending_requests
    @friend_requests = current_user.pending_friend_requests.includes(:sender)
  end
end
