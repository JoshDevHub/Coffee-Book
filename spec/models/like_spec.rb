# == Schema Information
#
# Table name: likes
#
#  id            :bigint           not null, primary key
#  likeable_type :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  likeable_id   :bigint           not null
#  liker_id      :bigint           not null
#
# Indexes
#
#  index_likes_on_likeable  (likeable_type,likeable_id)
#  index_likes_on_liker_id  (liker_id)
#
# Foreign Keys
#
#  fk_rails_...  (liker_id => users.id)
#
require "rails_helper"

RSpec.describe Like, type: :model do
  describe "notify" do
    let(:liker) { create(:user) }
    let(:liked_user) { create(:user) }

    context "when the like is on a post" do
      subject(:post_like) { create(:like, liker:, likeable: post) }

      let(:post) { create(:post, author: liked_user) }

      it "creates a new notification for the user with the liked post" do
        expect { post_like.notify(liker, liked_user) }
          .to change(liked_user.notifications, :count).from(0).to(1)
      end

      it "creates a new notification with the expected message" do
        expected_message = "#{liker.name} liked your post."
        created_message = post_like.notify(liker, liked_user).message

        expect(created_message).to eq(expected_message)
      end

      it "creates a new notification with the expected path" do
        expected_url = "/posts/#{post.id}"
        created_url = post_like.notify(liker, liked_user).url

        expect(created_url).to eq(expected_url)
      end
    end

    context "when the like is on a comment" do
      subject(:comment_like) { create(:like, liker:, likeable: comment) }

      let(:post) { create(:post) }
      let(:comment) { create(:comment, commenter: liked_user, commentable: post) }

      it "creates a new notification for the user with the liked comment" do
        expect { comment_like.notify(liker, liked_user) }
          .to change(liked_user.notifications, :count).from(0).to(1)
      end

      it "creates a new notification with the expected message" do
        expected_message = "#{liker.name} liked your comment."
        created_message = comment_like.notify(liker, liked_user).message

        expect(created_message).to eq(expected_message)
      end

      it "creates a new notification with the expected url" do
        expected_url = "/posts/#{post.id}"
        created_url = comment_like.notify(liker, liked_user).url

        expect(created_url).to eq(expected_url)
      end
    end

    context "when the user likes their own post" do
      subject(:post_like) { create(:like, liker:, likeable: post) }

      let(:liker) { create(:user) }
      let(:post) { create(:post, author: liker) }

      it "does not create a notification" do
        expect { post_like.notify(liker, post.author) }
          .not_to change(Notification, :count)
      end
    end

    context "when the user likes their own comment" do
      subject(:comment_like) { create(:like, liker:, likeable: comment) }

      let(:post) { create(:post, author: liker) }
      let(:comment) { create(:comment, commenter: liker) }

      it "does not create a notification" do
        expect { comment_like.notify(liker, post.author) }
          .not_to change(Notification, :count)
      end
    end
  end
end
