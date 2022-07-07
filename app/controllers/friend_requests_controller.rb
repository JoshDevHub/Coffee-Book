class FriendRequestsController < ApplicationController
  def index
    @friends = current_user.friends
  end

  def show
    @friend_request = FriendRequest.find(params[:id])
  end

  def create
    @friend_request = current_user.sent_friend_requests.build(friend_request_params)
    flash[:success] = "Friend Request Sent" if @friend_request.save

    redirect_to users_path
  end

  def destroy
    @friend_request = FriendRequest.find(params[:id])
    @friend_request.destroy

    redirect_to root_path, status: :see_other
  end

  def confirm_request
    @friend_request = FriendRequest.find(params[:id])
    @friend_request.confirm
    flash[:notice] = "Friend Added"
    redirect_to root_path, status: :see_other
  end

  private

  def friend_request_params
    params.require(:friend_request).permit(:sender, :receiver_id)
  end
end
