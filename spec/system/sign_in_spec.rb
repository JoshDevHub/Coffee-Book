require "rails_helper"

RSpec.describe "Sign in" do
  let!(:user) { create(:user, email: "example@coffee.com") }

  context "with valid credentials" do
    it "allows the user to sign in" do
      visit root_path

      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_on "Log in"

      expect(page).to have_current_path(root_path)
    end
  end

  context "with invalid credentials" do
    it "notifies the user of invalid credentials" do
      visit root_path

      fill_in "Email", with: "not_email"
      fill_in "Password", with: user.password

      expect(page).to have_current_path(new_user_session_path)
      expect(page).to have_content("You need to sign in or sign up before continuing.")
    end
  end
end
