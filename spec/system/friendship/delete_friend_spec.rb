require "rails_helper"

RSpec.describe "Deleting a friend" do
  context "when rejecting a request" do
    let(:sender) { create(:user) }
    let(:receiver) { create(:user, :friend) }

    before do
      friendship = create(:friendship, sender:, receiver:)
      friendship.notify(sender, receiver)
      login_as(receiver)
    end

    it "deletes the friend request" do
      visit notifications_path
      click_on "View"
      click_on "Reject"

      expect(page).not_to have_content("Friend Request")

      expect(page).to have_content("Request denied")
    end
  end

  context "when canceling a friend request" do
    let(:sender) { create(:user) }
    let(:receiver) { create(:user) }

    before do
      create(:friendship, sender:, receiver:)
      login_as(sender)
    end

    it "deletes the friendship" do
      visit users_path
      expect(page).to have_content("Pending ...")

      accept_confirm do
        find("button[aria-label='Cancel Friend Request']").click
      end

      expect(page).not_to have_content("Pending ...")
    end
  end

  context "when deleting a current friend" do
    let(:sender) { create(:user) }
    let(:receiver) { create(:user) }

    before do
      create(:friendship, sender:, receiver:, accepted: true)
      login_as(sender)
    end

    it "deletes the friendship" do
      visit user_friends_path(sender.username)
      expect(page).to have_content(receiver.name)

      accept_confirm do
        find("button[aria-label='Remove Friend']").click
      end

      expect(page).not_to have_content(receiver.name)
      expect(page).to have_content("Friend removed")
    end
  end
end
