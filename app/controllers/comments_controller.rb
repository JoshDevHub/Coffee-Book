class CommentsController < ApplicationController
  before_action :find_comment_for_current_user, only: %i[edit update destroy]
  before_action :post_param, only: %i[create]

  # POST posts/:id/comments
  def create
    @comment = @post.comments.new(comment_params)
    @comment.commenter = current_user
    if @comment.save
      flash[:success] = "Your comment has been added"
      @comment.notify(current_user, @post.author)
    else
      flash[:error] = "Comment body cannot be blank"
    end
    redirect_to root_path
  end

  # GET "/comments/:id/edit"
  def edit; end

  # PATCH "/comments/:id"
  def update
    if @comment.update(comment_params)
      redirect_to root_path
    else
      flash.now[:error] = "Body can't be blank"
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE "/comments/:id"
  def destroy
    @comment.destroy
    flash[:success] = "Comment deleted"

    redirect_to root_path, status: :see_other
  end

  private

  def post_param
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:commenter, :post, :body)
  end

  def find_comment_for_current_user
    @comment = current_user.comments.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "You do not own this comment"
    redirect_to root_path
  end
end
