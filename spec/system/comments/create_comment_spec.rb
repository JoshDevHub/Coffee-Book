require "rails_helper"

RSpec.describe "Creating a comment", type: :system do
  let!(:commenting_user) { create(:user) }
  let!(:posting_user) { create(:user) }

  before do
    login_as(commenting_user)
    create(
      :friendship,
      sender: commenting_user,
      receiver: posting_user,
      accepted: true
    )
    create(:post, author: posting_user)
  end

  context "when the inputs are valid" do
    it "creates a new comment" do
      visit root_path
      fill_in "Body", with: "Test Comment"
      click_on "Create Comment"

      expect(page).to have_content("Test Comment")
    end

    it "sends a notification to the posting user" do
      visit root_path
      fill_in "Body", with: "Test Comment"
      click_on "Create Comment"
      sleep 0.5

      login_as(posting_user)
      visit user_notifications_path(posting_user)
      expect(page).to have_content("#{commenting_user.name} commented on your post.")
    end
  end

  context "when the inputs are not valid" do
    it "renders an error message" do
      error_message = "Comment body cannot be blank"
      visit root_path
      click_on "Create Comment"

      expect(page).to have_content(error_message)
    end
  end
end
