require "rails_helper"

RSpec.describe "Sending a friend request", type: :system do
  let(:current_user) { create(:user) }
  let(:other_user) { create(:user) }

  before do
    login_as(current_user)
    create(:user)
  end

  context "when the two users are not friends" do
    it "sends a friend request to the other user" do
      visit users_path
      click_on "Friend this User"

      expect(page).to have_content("Pending request ...")
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
      expect(find_button("You're friends with this user.", disabled: true)).to be_truthy
    end
  end
end
