require "rails_helper"

RSpec.describe "Sending a friend request", type: :system do
  let!(:current_user) { create(:user) }
  let!(:other_user) { create(:user) }

  before do
    login_as(current_user)
  end

  context "when the two users are not friends" do
    it "says a friend request is pending between the users" do
      visit users_path
      click_on "Friend this User"

      expect(page).to have_content("Pending request ...")
    end

    it "notifies the receiving user of a request" do
      visit users_path
      click_on "Friend this User"
      sleep 0.5

      login_as(other_user)
      visit user_notifications_path(other_user)
      expect(page).to have_content("#{current_user.name} sent you a friend request!")
    end
  end

  context "when two users are friends" do
    before do
      create(
        :friendship,
        sender: current_user,
        receiver: other_user,
        accepted: true
      )
    end

    it "prevents the button from being clicked" do
      visit users_path
      expect(find_button("Friend", disabled: true)).to be_truthy
    end
  end
end
