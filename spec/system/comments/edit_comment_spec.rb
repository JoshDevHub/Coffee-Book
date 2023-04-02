require "rails_helper"

RSpec.describe "Editing a comment" do
  let(:user) { create(:user) }
  let!(:post) { create(:post, author: user) }

  before do
    login_as(user)
    create(:comment, commenter: user, post:)
  end

  context "when the inputs are valid" do
    it "updates the comment with the new text" do
      visit post_path(post)
      find("button[aria-label='Edit Comment']").click
      fill_in "Body", with: "Edited Comment"
      click_on "Update Comment"

      expect(page).to have_content("Edited Comment")
    end
  end

  context "when the inputs are invalid" do
    let(:error_message) { "Body can't be blank" }

    it "rerenders the edit page" do
      visit post_path(post)
      find("button[aria-label='Edit Comment']").click
      fill_in "Body", with: ""
      click_on "Update Comment"

      expect(page).to have_content(error_message)
    end
  end

  context "when the user doesn't own the comment" do
    let(:others_comment) { create(:comment, commenter: create(:user), post:) }

    it "renders an error message" do
      error_message = "You do not own this comment"
      visit edit_comment_path(others_comment)

      expect(page).to have_content(error_message)
    end
  end
end
