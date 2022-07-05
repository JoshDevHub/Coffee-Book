require "rails_helper"

RSpec.describe "Creating a like", type: :system do
  let(:user) { create(:user) }

  before do
    login_as(user)
    create(:post, user: user)
  end

  it "creates a Like" do
    visit root_path
    click_on "Like"
    expect(page).to have_content("Likes: 1")
  end
end
