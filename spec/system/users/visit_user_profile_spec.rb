require "rails_helper"

RSpec.describe "Visiting user profile", type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user, id: 5, first_name: "Bob", last_name: "Jones") }

  before do
    login_as(user)
  end

  context "when using user path with a valid username" do
    it "shows the profile" do
      visit user_path(other_user.username)
      expect(page).to have_content("#{other_user.first_name}'s Posts")
    end
  end
end
