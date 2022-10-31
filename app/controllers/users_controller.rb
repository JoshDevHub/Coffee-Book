class UsersController < ApplicationController
  # GET "/users"
  def index
    @users = if params[:search].present?
               User.include_avatar.search_by_name(params[:search])
             else
               User.include_avatar.index_for(current_user)
             end
  end

  # GET "/user/:username"
  def show
    @user = User.includes(posts: :photo_attachment).find_by!(username: params[:username])
    @profile = ProfileDecorator.new(@user.profile)
  end
end
