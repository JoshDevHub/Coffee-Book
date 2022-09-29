class LikesController < ApplicationController
  def create
    @like = current_user.likes.build(like_params)
    @like.notify(current_user, @like.likeable.author) if @like.save
    redirect_back fallback_location: root_path
  end

  def destroy
    @like = Like.find(params[:id])
    @like.destroy

    redirect_back fallback_location: root_path
  end

  private

  def like_params
    params.require(:like).permit(:likeable_id, :likeable_type, :liker)
  end
end
