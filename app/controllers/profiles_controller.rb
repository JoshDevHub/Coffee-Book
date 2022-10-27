class ProfilesController < ApplicationController
  before_action :find_profile_for_current_user, only: %i[edit update]

  # GET "users/:id/profile"
  def edit; end

  # PATCH "users/:id/profile"
  def update
    if @profile.update(profile_params)
      redirect_to user_path(current_user.username)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:gender, :birthday, :location, :avatar, :bio)
  end

  def find_profile_for_current_user
    if current_user.id == params[:user_id].to_i
      @profile = current_user.profile
    else
      flash[:error] = "Unauthorized Access!"
      redirect_to root_path
    end
  end
end
