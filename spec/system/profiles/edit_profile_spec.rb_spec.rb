require "rails_helper"

RSpec.describe "Editing a profile", type: :system do
  let(:user) { create(:user) }

  before do
    login_as(user)
  end

  context "when the inputs are valid" do
    it "updates the profile" do
      visit edit_user_profile_path(user)
      fill_in "Bio", with: "I'm a test user"
      select "male", from: "Gender"
      fill_in "Location", with: "United States"
      fill_in "Birthday", with: "10/05/1990"
      click_on "Update Profile"

      expect(page).to have_content("United States")
    end
  end

  context "when the user visits the edit path for a different user" do
    it "flashes an error message" do
      error_message = "Access denied"
      other_user = create(:user)
      visit edit_user_profile_path(other_user)

      expect(page).to have_content(error_message)
    end
  end
end
