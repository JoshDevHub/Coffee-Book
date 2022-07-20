require "rails_helper"

RSpec.describe "Editing a profile", type: :system do
  let(:user) { create(:user) }

  before do
    login_as(user)
  end

  context "when the inputs are valid" do
    it "updates the profile" do
      visit edit_user_profile_path(user)
      select "male", from: "Gender"
      fill_in "Country", with: "United States"
      fill_in "Birthday", with: "10/05/1990"
      click_on "Update Profile"

      expect(page).to have_content("United States")
    end
  end
end
