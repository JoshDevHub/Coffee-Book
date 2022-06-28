class FriendRequestsController < ApplicationController
  def show
    @friend_request = FriendRequest.find(params[:id])
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
end
