require "rails_helper"

RSpec.describe "Editing a comment", type: :system do
  let(:user) { create(:user) }
  let(:post) { create(:post, user: user) }

  before do
    login_as(user)
    create(:comment, user: user, commentable: post)
  end

  context "when the inputs are valid" do
    it "creates a new comment" do
      visit post_path(post)
      click_on "Edit Comment"
      fill_in "Body", with: "Edited Comment"
      click_on "Update Comment"

      expect(page).to have_content("Edited Comment")
    end
  end

  context "when the inputs are invalid" do
    let(:error_message) { "Body can't be blank" }

    it "rerenders the edit page" do
      visit post_path(post)
      click_on "Edit Comment"
      fill_in "Body", with: ""
      click_on "Update Comment"

      expect(page).to have_content(error_message)
    end
  end
end
