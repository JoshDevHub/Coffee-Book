require "rails_helper"

RSpec.describe User, type: :model do
  describe "#send_friend_request" do
    subject(:request_sender) { create(:user) }

    let(:receiver) { create(:user) }

    context "when no request exists between the two users" do
      it "creates a new FriendRequest record" do
        expect { request_sender.send_friend_request(receiver) }.to change(FriendRequest, :count).by(1)
      end
    end

    context "when a request already exists between the two users" do
      before do
        FriendRequest.create(sender: request_sender, receiver: receiver)
      end

      it "does not create a new FriendRequest record" do
        expect { request_sender.send_friend_request(receiver) }.not_to change(FriendRequest, :count)
      end
    end
  end
end
