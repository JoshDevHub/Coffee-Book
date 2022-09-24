class FriendshipsController < ApplicationController
  # GET "/users/:id/friends"
  # GET "/users/:id/friendships"
  def index
    @friends = current_user.friends_with_avatar
  end

  # GET "/users/:id/friendships"
  def show
    @friendship = Friendship.find(params[:id])
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

    redirect_to user_notifications_path(current_user), status: :see_other
  end

  # PATCH "/friendships/:id/confirm_request"
  def confirm_request
    @friendship = Friendship.find(params[:id])
    @friendship.confirm
    flash[:notice] = "Friend Added"
    redirect_back fallback_location: root_path
  end

  private

  def friendship_params
    params.require(:friendship).permit(:sender, :receiver_id)
  end
end
