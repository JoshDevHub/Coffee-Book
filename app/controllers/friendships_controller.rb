class FriendshipsController < ApplicationController
  def index
    @friends = current_user.friends
  end

  def show
    @friendship = Friendship.find(params[:id])
  end

  def create
    @friendship = current_user.sent_friend_requests.build(friendship_params)
    if @friendship.save
      flash[:success] = "Friend Request Sent"
      @friendship.notify(@friendship.sender, @friendship.receiver)
    end

    redirect_back fallback_location: root_path
  end

  def destroy
    @friendship = Friendship.find(params[:id])
    @friendship.destroy
    flash[:notice] = "Request denied"

    redirect_to user_notifications_path(current_user), status: :see_other
  end

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
