require "rails_helper"

RSpec.describe "Deleting a post", type: :system do
  let(:user) { create(:user) }
  let(:post) { Post.create(body: "Test post", user: user) }

  before do
    login_as(user)
  end

  it "Deletes the post" do
    visit post_path(post)
    click_on "Delete Post"
    expect(page).not_to have_content("Test post")
  end
end
