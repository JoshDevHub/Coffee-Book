require "rails_helper"

RSpec.describe "Editing a post", type: :system do
  let(:user) { create(:user) }
  let(:post) { Post.create(body: "Test Post", user: user) }

  before do
    login_as(user)
  end

  context "when inputs are valid" do
    it "updates the post" do
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

  context "when the user doesn't own the post" do
    let(:others_post) { create(:post, user: create(:user)) }

    it "renders an error message" do
      error_message = "You do not own this Post"
      visit edit_post_path(others_post)

      expect(page).to have_content("You do not own this Post")
    end
  end
end
