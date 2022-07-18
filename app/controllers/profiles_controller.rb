class ProfilesController < ApplicationController
  def show
    @profile = Profile.find_by(user_id: params[:user_id])
  end

  def edit
    @profile = Profile.find_by(user_id: params[:user_id])
  end

  def update
    @profile = Profile.find(params[:user_id])

    if @profile.update(profile_params)
      redirect_to user_profile_path(current_user)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:gender, :birthday, :country)
  end
end
