require "rails_helper"

RSpec.describe "Deleting a friend", type: :system do
  let(:sender) { create(:user) }
  let(:receiver) { create(:user) }

  before do
    friendship = create(:friendship, sender:, receiver:)
    friendship.notify(sender, receiver)
    login_as(receiver)
  end

  it "Deletes the friendship" do
    visit notifications_path
    click_on "View"
    click_on "Reject"

    expect(page).not_to have_content("Friend Request")

    expect(page).to have_content("Request denied")
  end
end