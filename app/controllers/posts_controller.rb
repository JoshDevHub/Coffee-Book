class PostsController < ApplicationController
  def index
    @posts = Post.timeline_for(current_user)
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])

    if @post.update(post_params)
      redirect_to @post
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    redirect_to root_path, status: :see_other
  end

  def like_post
    @post = Post.find(params[:id])
    @post.likes.create(user: current_user)
    redirect_to root_path
  end

  private

  def post_params
    params.require(:post).permit(:body, :user_id)
  end
end
