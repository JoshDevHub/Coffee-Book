require "rails_helper"

RSpec.describe "Destroying a comment", type: :system do
  let(:user) { create(:user) }

  before do
    login_as(user)
    post = create(:post, user: user)
    create(:comment, commentable: post, user: user)
  end

  it "destroys the comment" do
    visit root_path
    click_on "View Post"
    click_on "Delete Comment"

    expect(page).to have_content("Comment deleted")
  end
end
