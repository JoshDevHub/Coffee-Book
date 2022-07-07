# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  body       :string
#  user_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "rails_helper"

RSpec.describe Post, type: :model do
  describe "#total_likes" do
    let(:current_user) { create(:user) }

    context "when a post has no likes" do
      subject(:unliked_post) { create(:post, user: current_user) }

      it "returns 0" do
        expect(unliked_post.total_likes).to eq 0
      end
    end

    context "when the post has 3 likes" do
      subject(:popular_post) { create(:post, user: current_user) }

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
      subject(:liked_post) { create(:post, user: current_user) }

      it "returns the like" do
        post_like = create(:like, user: current_user, likeable: liked_post)
        expect(liked_post.find_like_from(current_user)).to eq post_like
      end
    end

    context "when a post is not liked by the user" do
      subject(:unliked_post) { create(:post, user: current_user) }

      it "returns nil" do
        expect(unliked_post.find_like_from(current_user)).to be_nil
      end
    end
  end
end
