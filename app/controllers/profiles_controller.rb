class ProfilesController < ApplicationController
  # GET "profile/edit"
  def edit
    @profile = current_user.profile
  end

  # PATCH "/profile"
  def update
    @profile = current_user.profile

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
end
