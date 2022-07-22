require "rails_helper"

RSpec.describe "Deleting a friend", type: :system do
  let(:sending_user) { create(:user) }
  let(:accepting_user) { create(:user) }

  before do
    sending_user.send_friend_request(accepting_user)
    login_as(accepting_user)
  end

  it "Deletes the friendship" do
    visit user_notifications_path(accepting_user)
    click_on "Friend Request"
    click_on "Reject Request"

    expect(page).not_to have_content("Friend Request")

    expect(page).to have_content("Request denied")
  end
end
