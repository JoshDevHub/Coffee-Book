require "rails_helper"

RSpec.describe "Destroying a comment" do
  let(:user) { create(:user) }
  let(:post) { create(:post, author: user) }

  before do
    login_as(user)
    create(:comment, post:, commenter: user, body: "This comment will be deleted")
  end

  it "destroys the comment" do
    visit post_path(post)
    find("button[aria-label='Delete Comment']").click

    expect(page).to have_content("Comment deleted")
    expect(page).not_to have_content("This comment will be deleted")
  end
end
