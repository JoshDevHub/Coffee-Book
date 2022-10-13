class LikesController < ApplicationController
  before_action :find_like_for_current_user, only: :destroy

  def create
    @like = current_user.likes.build(like_params)
    @like.notify(current_user, @like.likeable.author) if @like.save

    respond_to do |format|
      format.html { redirect_back fallback_location: root_path }
      format.turbo_stream
    end
  end

  def destroy
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

  def find_like_for_current_user
    @like = current_user.likes.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Unauthorized Access!"
    redirect_to root_path
  end
end
