class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_signup_parameters, if: :devise_controller?
  before_action :configure_user_update_parameters, if: :devise_controller?

  protected

  # rubocop: disable Metrics/MethodLength
  def configure_user_update_parameters
    devise_parameter_sanitizer.permit(:account_update) do |user_params|
      user_params.permit(
        :first_name,
        :last_name,
        :username,
        :email,
        :current_password,
        :password,
        :password_confirmation
      )
    end
  end
  # rubocop: enable Metrics/MethodLength

  def configure_signup_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |user_params|
      user_params.permit(
        :email,
        :first_name,
        :last_name,
        :username,
        :password,
        :password_confirmation
      )
    end
  end
end
