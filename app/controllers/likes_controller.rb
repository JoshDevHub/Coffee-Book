class LikesController < ApplicationController
  def create
    @like = Post.find(params[:post_id]).likes.build(user: current_user)
    @like.save
    redirect_to root_path
  end

  private

  def like_params
    params.require(:like).permit(:user, :likeable)
  end
end
