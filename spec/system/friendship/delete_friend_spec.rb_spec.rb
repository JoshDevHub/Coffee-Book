require "rails_helper"

RSpec.describe "Deleting a friend", type: :system do
  let(:sender) { create(:user) }
  let(:receiver) { create(:user) }

  before do
    friendship = create(:friendship, sender:, receiver:)
    create(:notification, notifiable: friendship, user: receiver)
    login_as(receiver)
  end

  it "Deletes the friendship" do
    visit user_notifications_path(receiver)
    click_on "View"
    click_on "Reject Request"

    expect(page).not_to have_content("Friend Request")

    expect(page).to have_content("Request denied")
  end
end
