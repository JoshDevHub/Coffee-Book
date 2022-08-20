class UsersController < ApplicationController
  def index
    @users = if params[:search].present?
               User.search_by_name(params[:search])
             else
               User.index_for(current_user)
             end
  end

  def show
    @user = User.includes(
      posts: [:photo_attachment, { comments: :commenter }]
    ).find(params[:id])
  end
end
