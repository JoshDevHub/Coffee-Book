require "rails_helper"

RSpec.describe "Reading notifications", type: :system do
  let(:current_user) { create(:user) }

  before do
    build_list(:notification, 5, user: current_user)
    login_as(current_user)
  end

  it "displays symbol indicating notifications" do
    visit root_path
    expect(page).to have_content("Notifications+")
  end

  it "removes symbol when notifications path is visited" do
    visit user_notifications_path(current_user)
    expect(page).not_to have_content("Notifications+")
  end
end
