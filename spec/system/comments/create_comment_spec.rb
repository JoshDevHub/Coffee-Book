require "rails_helper"

RSpec.describe "Creating a comment", type: :system do
  let(:user) { create(:user) }

  before do
    login_as(user)
    create(:post, author: user)
  end

  context "when the inputs are valid" do
    it "creates a new comment" do
      visit root_path
      click_on "View Post"
      fill_in "Body", with: "Test Comment"
      click_on "Create Comment"

      expect(page).to have_content("Test Comment")
    end
  end

  context "when the inputs are not valid" do
    it "renders an error message" do
      error_message = "Comment body cannot be blank"
      visit root_path
      click_on "View Post"
      click_on "Create Comment"

      expect(page).to have_content(error_message)
    end
  end
end
