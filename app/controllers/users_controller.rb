class UsersController < ApplicationController
  # GET "/users"
  def index
    query = if params[:search].present?
              [:search_by_name, params[:search]]
            else
              [:index_for, current_user]
            end
    @users = User.includes(profile: :avatar_attachment).public_send(*query)
  end

  # GET "/users/:id"
  def show
    @user = User.includes(posts: :photo_attachment).find(params[:id])
  end
end
