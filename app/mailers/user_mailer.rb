class UserMailer < ApplicationMailer
  default from: "notifications@example.com"

  def welcome_email
    @user = params[:user]
    @url = "<placeholder.com>"
    mail(to: @user.email, subject: "Welcome to Coffee Book!")
  end
end
