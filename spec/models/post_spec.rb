# == Schema Information
#
# Table name: posts
#
#  id             :bigint           not null, primary key
#  body           :string
#  comments_count :integer          default(0)
#  likes_count    :integer          default(0)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  author_id      :bigint           not null
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

  describe "photo#attach" do
    subject(:post_with_attachment) { create(:post) }

    context "when the photo is valid" do
      before do
        post_with_attachment.photo.attach(io: File.open("./spec/fixtures/valid_image.png"),
                                          filename: "valid_image.png",
                                          content_type: "image/png")
      end

      it "is valid" do
        expect(post_with_attachment).to be_valid
      end

      it "has a photo attached" do
        expect(post_with_attachment.photo).to be_attached
      end
    end

    context "when the photo isn't an image filetype" do
      before do
        post_with_attachment.photo.attach(io: File.open("./spec/fixtures/test_txtfile.txt"),
                                          filename: "test_txtfile.txt",
                                          content_type: "text/plain")
      end

      it "isn't valid" do
        expect(post_with_attachment).not_to be_valid
      end

      it "has an error with expected message" do
        expected_message = "is not a photo"
        expect(post_with_attachment.errors[:photo]).to match_array(expected_message)
      end
    end

    context "when the filesize is too large" do
      before do
        post_with_attachment.photo.attach(io: File.open("./spec/fixtures/large_file.png"),
                                          filename: "large_file.png",
                                          content_type: "image/png")
      end

      it "isn't valid" do
        expect(post_with_attachment).not_to be_valid
      end

      it "has an error with expected message" do
        expected_message = "size must be less than 5MB"
        expect(post_with_attachment.errors[:photo]).to match_array(expected_message)
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
