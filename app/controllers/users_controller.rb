class UsersController < ApplicationController
  around_action :skip_bullet, if: -> { defined?(Bullet) }, only: :show

  # GET "/users"
  def index
    @users = if params[:search].present?
               User.include_avatar.search_by_name(params[:search])
             else
               User.include_avatar.index_for(current_user)
             end
    @current_user_friendships = Friendship.for(current_user)
  end

  # GET "/user/:username"
  def show
    @user = User.includes(posts: :photo_attachment)
                .find_by!(username: params[:username])
  end

  private

  # for skipping query check on `users#show`
  def skip_bullet
    previous_value = Bullet.enable?
    Bullet.enable = false
    yield
  ensure
    Bullet.enable = previous_value
  end
end
