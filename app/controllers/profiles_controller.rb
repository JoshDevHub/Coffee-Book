class ProfilesController < ApplicationController
  before_action :enforce_profile_ownership, only: [:edit]

  # GET "users/:id/profile"
  def edit
    @profile = Profile.find_by(user_id: params[:user_id])
  end

  # PATCH "users/:id/profile"
  def update
    @profile = Profile.find(params[:user_id])

    if @profile.update(profile_params)
      redirect_to user_path(current_user)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:gender, :birthday, :location, :avatar)
  end

  def enforce_profile_ownership
    return if params[:user_id].to_i == current_user.id

    flash[:error] = "Access denied"
    redirect_to root_path
  end
end
