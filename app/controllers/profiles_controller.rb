class ProfilesController < ApplicationController
  before_action :enforce_profile_ownership, only: %i[edit update]

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

  def enforce_profile_ownership
    return if params[:user_id] != current_user.id

    flash[:error] = "Access denied"
    redirect_to root_path
  end
end
