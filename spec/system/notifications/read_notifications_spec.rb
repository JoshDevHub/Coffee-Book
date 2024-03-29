require "rails_helper"

RSpec.describe "Reading notifications" do
  let(:current_user) { create(:user) }

  before do
    create_list(:notification, 5, user: current_user)
    login_as(current_user)
  end

  it "displays symbol indicating notifications" do
    visit root_path
    expect(page).to have_selector("#notifications-badge")
  end

  it "removes symbol when notifications path is visited" do
    visit notifications_path
    expect(page).not_to have_selector("#notifications-badge")
  end
end
