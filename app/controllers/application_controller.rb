class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |user_params|
      user_params.permit(
        :email,
        :first_name,
        :last_name,
        :password,
        :password_confirmation
      )
    end
  end

  private

  def enforce_user_ownership
    resource = controller_name.classify.constantize
    return if resource.find(params[:id]).user == current_user

    flash[:error] = "You do not own this #{resource}"
    redirect_to root_path
  end
end
