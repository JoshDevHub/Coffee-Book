require "rails_helper"

RSpec.describe "Confirming a friend request", type: :system do
  let(:sending_user) { create(:user) }
  let(:accepting_user) { create(:user) }

  context "when the friend request is pending" do
    before do
      sending_user.send_friend_request(accepting_user)
      login_as(accepting_user)
    end

    it "accepts the friend request" do
      visit user_notifications_path(accepting_user)
      click_on "Friend Request"
      click_on "Confirm Request"

      expect(page).to have_content("Friend Added")
    end
  end

  context "when the friend request has been accepted" do
    before do
      sending_user.send_friend_request(accepting_user)
      accepting_user.received_friend_requests.first.confirm
      login_as(accepting_user)
    end

    it "tells the user that they already have this friendship" do
      visit user_notifications_path(accepting_user)
      click_on "Friend Request"

      expect(page).to have_content("You are already friends")
    end
  end
end
