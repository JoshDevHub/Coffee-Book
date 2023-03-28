require "rails_helper"

RSpec.describe "Sign up" do
  let(:name) { "Josh" }
  let(:password) { "ExamplePassword" }

  context "with valid credentials" do
    it "allows the user to sign up" do
      visit new_user_registration_path

      fill_in "First name", with: name
      fill_in "Last name", with: "Smith"
      fill_in "Email", with: "new_user@example.com"
      fill_in "Username", with: "new-user"
      fill_in "Password", with: password
      fill_in "Password confirmation", with: password
      click_on "Sign up"

      expect(page).to have_content("#{name}'s Posts")
    end
  end

  context "with invalid credentials" do
    context "when the username is invalid" do
      it "notifies the user of invalid credentials" do
        visit new_user_registration_path

        fill_in "First name", with: name
        fill_in "Last name", with: "Smith"
        fill_in "Email", with: "new_user@example.com"
        fill_in "Username", with: "new_user"
        fill_in "Password", with: password
        fill_in "Password confirmation", with: password
        click_on "Sign up"

        expect(page).to have_content("Username only allows letters and dashes")
      end
    end
  end
end
