class LikesController < ApplicationController
  def create
    post = Post.find(params[:post_id])
    @like = post.likes.build(liker: current_user)
    @like.notify(current_user, post.author) if @like.save
    redirect_back fallback_location: root_path
  end

  def destroy
    @like = Like.find(params[:id])
    @like.destroy

    redirect_back fallback_location: root_path
  end
end
