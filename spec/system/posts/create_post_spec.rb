require "rails_helper"

RSpec.describe "Creating a post", type: :system do
  let(:user) { User.create(email: "test@example.com", password: "password123") }

  before do
    login_as(user)
  end

  context "when inputs are valid" do
    it "creates a new post" do
      visit new_post_path
      fill_in "Body", with: "Test Post"
      click_on "Create Post"

      expect(page).to have_content("Test Post")
    end
  end

  context "when inputs are invalid" do
    it "renders an error message" do
      error_message = "Body can't be blank"
      visit new_post_path
      click_on "Create Post"

      expect(page).to have_content(error_message)
    end
  end
end
