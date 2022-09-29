class LikesController < ApplicationController
  def create
    @like = current_user.likes.build(like_params)
    @like.notify(current_user, @like.likeable.author) if @like.save

    respond_to do |format|
      format.html { redirect_back fallback_location: root_path }
      format.turbo_stream
    end
  end

  def destroy
    @like = Like.find(params[:id])
    @like.destroy

    respond_to do |format|
      format.html { redirect_back fallback_location: root_path }
      format.turbo_stream
    end
  end

  private

  def like_params
    params.require(:like).permit(:likeable_id, :likeable_type, :liker)
  end
end
