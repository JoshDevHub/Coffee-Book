class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new(comment_params)
    @comment.user = current_user
    if @comment.save
      flash[:success] = "Your comment has been added"
    else
      flash[:error] = "Comment body cannot be blank"
    end
    redirect_to post_path(@post)
  end

  private

  def comment_params
    params.require(:comment).permit(:user, :commentable, :body)
  end
end
