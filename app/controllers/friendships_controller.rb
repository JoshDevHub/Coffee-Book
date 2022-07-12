class FriendshipsController < ApplicationController
  def index
    @friends = current_user.friends
  end

  def show
    @friendship = Friendship.find(params[:id])
  end

  def create
    @friendship = current_user.sent_friend_requests.build(friendship_params)
    flash[:success] = "Friend Request Sent" if @friendship.save

    redirect_to users_path
  end

  def destroy
    @friendship = Friendship.find(params[:id])
    @friendship.destroy

    redirect_to root_path, status: :see_other
  end

  def confirm_request
    @friendship = Friendship.find(params[:id])
    @friendship.confirm
    flash[:notice] = "Friend Added"
    redirect_to root_path, status: :see_other
  end

  private

  def friendship_params
    params.require(:friendship).permit(:sender, :receiver_id)
  end
end
