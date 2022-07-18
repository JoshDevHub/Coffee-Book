require "rails_helper"

RSpec.describe "Deleting a like", type: :system do
  let(:user) { create(:user) }

  before do
    login_as(user)
    post = create(:post, author: user)
    create(:like, liker: user, likeable: post)
  end

  it "deletes the Like" do
    visit root_path
    click_on "Unlike"
    expect(page).to have_content("Likes: 0")
  end
end
