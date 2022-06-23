require "rails_helper"

RSpec.describe "Creating a post", type: :system do
  let(:user) { create(:user) }
  let(:post) { Post.create(body: "Test Post", user: user) }

  before do
    login_as(user)
  end

  context "when inputs are valid" do
    it "creates a new post" do
      visit edit_post_path(post)
      fill_in "Body", with: "Updated Post"
      click_on "Create Post"

      expect(page).to have_content("Updated Post")
    end
  end

  context "when inputs are invalid" do
    it "renders an error message" do
      error_message = "Body can't be blank"
      visit edit_post_path(post)
      fill_in "Body", with: ""
      click_on "Create Post"

      expect(page).to have_content(error_message)
    end
  end
end
