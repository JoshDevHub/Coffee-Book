# == Schema Information
#
# Table name: comments
#
#  id               :bigint           not null, primary key
#  body             :text
#  commentable_type :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  commentable_id   :bigint           not null
#  commenter_id     :bigint           not null
#
# Indexes
#
#  index_comments_on_commentable   (commentable_type,commentable_id)
#  index_comments_on_commenter_id  (commenter_id)
#
# Foreign Keys
#
#  fk_rails_...  (commenter_id => users.id)
#
require "rails_helper"

RSpec.describe Comment, type: :model do
  describe "#notify" do
    subject(:comment) { create(:comment, commenter:, commentable: commented_post) }

    let(:poster) { create(:user) }
    let(:commented_post) { create(:post, author: poster) }
    let(:commenter) { create(:user) }

    it "creates a new Notification for the poster user" do
      expect { comment.notify(commenter, poster) }
        .to change(poster.notifications, :count).from(0).to(1)
    end

    it "creates a new Notification with the expected message" do
      expected_message = "#{commenter.name} commented on your post."
      created_message = comment.notify(commenter, poster).message

      expect(created_message).to eq(expected_message)
    end

    it "creates a new Notification with the comment path as the url" do
      expected_url = "comment_path"
      created_url = comment.notify(commenter, poster).url

      expect(created_url).to eq(expected_url)
    end
  end
end
