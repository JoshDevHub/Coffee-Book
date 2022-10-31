require "rails_helper"

RSpec.describe "Confirming a friend request", type: :system do
  let(:sender) { create(:user) }
  let(:receiver) { create(:user) }

  context "when the friend request is pending" do
    before do
      friendship = create(:friendship, sender:, receiver:)
      friendship.notify(sender, receiver)
      login_as(receiver)
    end

    it "accepts the friend request" do
      visit notifications_path
      click_on "View"
      click_on "Confirm"

      expect(page).to have_content("Friend Added")
    end
  end

  context "when the friend request has been accepted" do
    before do
      friendship = create(:friendship, sender:, receiver:)
      friendship.notify(sender, receiver)
      receiver.received_friend_requests.first.confirm
      login_as(receiver)
    end

    it "tells the user that they already have this friendship" do
      visit notifications_path
      click_on "View"

      expect(page).to have_content("Friend")
    end
  end
end
