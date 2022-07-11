class ProfilesController < ApplicationController
  def show
    @profile = Profile.find_by(user_id: params[:user_id])
  end

  def edit; end

  def update; end
end
