class PostsController < ApplicationController
  before_action :find_post_for_current_user, only: %i[edit update destroy]

  # GET "/"
  def index
    @posts = Post.timeline_for(current_user)
                 .includes(:author, :photo_attachment)
  end

  # GET "/posts/:id"
  def show
    @post = Post.includes(comments: :commenter).find(params[:id])
  end

  # GET "/posts/new"
  def new
    @post = Post.new
  end

  # POST "/posts"
  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET "/posts/:id/edit"
  def edit; end

  # PATCH "/posts/:id"
  def update
    if @post.update(post_params)
      redirect_to root_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE "/posts/:id"
  def destroy
    @post.destroy

    redirect_to root_path, status: :see_other
  end

  private

  def post_params
    params.require(:post).permit(:body, :photo, :author_id)
  end

  def find_post_for_current_user
    @post = current_user.posts.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "You do not own this post"
    redirect_to root_path
  end
end
