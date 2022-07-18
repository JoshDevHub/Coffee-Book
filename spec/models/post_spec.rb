# == Schema Information
#
# Table name: posts
#
#  id          :bigint           not null, primary key
#  body        :string
#  likes_count :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  author_id   :bigint           not null
#
# Indexes
#
#  index_posts_on_author_id  (author_id)
#
# Foreign Keys
#
#  fk_rails_...  (author_id => users.id)
#
require "rails_helper"

RSpec.describe Post, type: :model do
  describe "::timeline_for" do
    let(:main_user) { create(:user) }
    let(:friend) { create(:user) }
    let(:not_friend) { create(:user) }

    before do
      create(:friendship, sender: main_user, receiver: friend, accepted: true)
    end

    it "returns posts from the main user and their friend" do
      first_post = create(:post, author: main_user)
      second_post = create(:post, author: friend)

      record_object = described_class.timeline_for(main_user)
      expect(record_object).to include(first_post, second_post)
    end

    it "orders the timeline posts in descending order" do
      create(:post, author: main_user)
      second_post = create(:post, author: friend)

      record_object = described_class.timeline_for(main_user)
      expect(record_object.first).to eq second_post
    end

    it "does not return a post from the user who isn't a friend" do
      second_post = create(:post, author: not_friend)

      record_object = described_class.timeline_for(main_user)
      expect(record_object).not_to include(second_post)
    end
  end

  describe "#total_likes" do
    let(:current_user) { create(:user) }

    context "when a post has no likes" do
      subject(:unliked_post) { create(:post, author: current_user) }

      it "returns 0" do
        expect(unliked_post.total_likes).to eq 0
      end
    end

    context "when the post has 3 likes" do
      subject(:popular_post) { create(:post, author: current_user) }

      before do
        create(:like, likeable: popular_post)
        create(:like, likeable: popular_post)
        create(:like, likeable: popular_post)
      end

      it "returns 3" do
        expect(popular_post.total_likes).to eq 3
      end
    end
  end

  describe "#find_like_from" do
    let(:current_user) { create(:user) }

    context "when a post is liked by the user" do
      subject(:liked_post) { create(:post, author: current_user) }

      it "returns the like" do
        post_like = create(:like, liker: current_user, likeable: liked_post)
        expect(liked_post.find_like_from(current_user)).to eq post_like
      end
    end

    context "when a post is not liked by the user" do
      subject(:unliked_post) { create(:post, author: current_user) }

      it "returns nil" do
        expect(unliked_post.find_like_from(current_user)).to be_nil
      end
    end
  end
end
