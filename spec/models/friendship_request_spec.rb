# == Schema Information
#
# Table name: friendships
#
#  id          :bigint           not null, primary key
#  accepted    :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  receiver_id :bigint           not null
#  sender_id   :bigint           not null
#
# Indexes
#
#  index_friendships_on_receiver_id  (receiver_id)
#  index_friendships_on_sender_id    (sender_id)
#
# Foreign Keys
#
#  fk_rails_...  (receiver_id => users.id)
#  fk_rails_...  (sender_id => users.id)
#
require "rails_helper"

RSpec.describe Friendship, type: :model do
  describe "#confirm" do
    let(:sender) { create(:user) }
    let(:receiver) { create(:user) }

    context "when the request is unaccepted" do
      subject(:unaccepted_request) { described_class.create(sender:, receiver:) }

      it "changes the accepted attribute to true" do
        expect { unaccepted_request.confirm }.to change(unaccepted_request, :accepted).to true
      end

      it "saves the new accepted attribute value" do
        unaccepted_request.confirm
        expect(unaccepted_request.saved_changes).to include("accepted")
      end
    end

    context "when the request is already accepted" do
      subject(:accepted_request) { described_class.create(sender:, receiver:, accepted: true) }

      it "keeps the accepted attribute true" do
        expect { accepted_request.confirm }.not_to change(accepted_request, :accepted).from true
      end
    end
  end

  describe "#notify" do
    subject(:friend_request) { described_class.create(sender:, receiver:) }

    let(:sender) { create(:user) }
    let(:receiver) { create(:user) }

    it "creates a new notification for the receiving user" do
      expect { friend_request.notify(sender, receiver) }.to change(Notification, :count).by(1)
    end

    it "creates a new notification with the expected friend request message" do
      friend_request.notify(sender, receiver)
      expected_message = "#{sender.name} sent you a friend request!"

      expect(Notification.last.message).to eq(expected_message)
    end

    it "creates a new notification with the friendship path as the url" do
      friend_request.notify(sender, receiver)
      expected_url = "friendship_path"

      expect(Notification.last.url).to eq(expected_url)
    end
  end
end
