require "rails_helper"

RSpec.describe "Viewing friend list", type: :system do
  let(:current_user) { create(:user) }

  before do
    login_as(current_user)
    friend = create(:user, first_name: "UserFriend")
    create(:user, first_name: "NotFriend")
    create(:friendship, receiver: current_user, sender: friend, accepted: true)
  end

  it "has friend's name on the page" do
    visit friend_list_path(current_user)

    expect(page).to have_content("UserFriend")
  end

  it "does not have the user who isn't a friend on the page" do
    visit friend_list_path(current_user)

    expect(page).not_to have_content("NotFriend")
  end
end
