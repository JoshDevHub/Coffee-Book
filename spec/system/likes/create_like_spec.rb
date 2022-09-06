require "rails_helper"

RSpec.describe "Creating a like", type: :system do
  let!(:liking_user) { create(:user) }

  context "when the like is on a post" do
    let!(:posting_user) { create(:user) }

    before do
      login_as(liking_user)
      create(:post, author: posting_user)
      create(
        :friendship,
        sender: liking_user,
        receiver: posting_user,
        accepted: true
      )
    end

    it "creates a Like" do
      visit root_path
      click_on "Like"
      expect(page).to have_content("Likes: 1")
    end

    it "notifies the posting user of a like" do
      visit root_path
      click_on "Like"
      sleep 0.5

      login_as(posting_user)
      visit user_notifications_path(posting_user)
      expect(page).to have_content("#{liking_user.name} liked your post.")
    end
  end
end
