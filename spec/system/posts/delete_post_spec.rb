require "rails_helper"

RSpec.describe "Deleting a post" do
  let(:user) { create(:user) }

  before do
    login_as(user)
    create(:post, body: "Test post", author: user)
  end

  it "Deletes the post" do
    visit root_path
    click_on "Delete"
    expect(page).not_to have_content("Test post")
  end
end
