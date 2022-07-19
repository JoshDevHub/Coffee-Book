class UsersController < ApplicationController
  def index
    @users = User.index_for(current_user)
  end
end
