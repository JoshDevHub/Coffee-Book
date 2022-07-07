# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  first_name             :string
#  last_name              :string
#
require "rails_helper"

RSpec.describe User, type: :model do
  describe "Validations" do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }

    describe "email uniqueness" do
      subject { build(:user) }

      it { should validate_uniqueness_of(:email).case_insensitive }
    end
  end

  describe "#send_friend_request" do
    subject(:request_sender) { create(:user) }

    let(:receiver) { create(:user) }

    context "when no request exists between the two users" do
      it "creates a new FriendRequest record" do
        expect { request_sender.send_friend_request(receiver) }.to(
          change { request_sender.sent_friend_requests.count }.by(1)
        )
      end

      it "creates a new Notification for the receiver" do
        expect { request_sender.send_friend_request(receiver) }.to(
          change { receiver.notifications.count }.by(1)
        )
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

  describe "#friends" do
    subject(:user) { create(:user) }

    context "when the users share an accepted request" do
      let(:users_friend) { create(:user) }

      before do
        FriendRequest.create(sender: user, receiver: users_friend, accepted: true)
      end

      it "returns a relation object including the user's friend" do
        expect(user.friends).to include(users_friend)
      end
    end

    context "when the users do not share a request" do
      it "returns a relation object not including the user who isn't a friend" do
        not_users_friend = create(:user)
        expect(user.friends).not_to include(not_users_friend)
      end
    end

    context "when the users share an unaccepted request" do
      it "does not include the other user if the request isn't accepted" do
        requested_user = create(:user)
        FriendRequest.create(sender: user, receiver: requested_user, accepted: false)
        expect(user.friends).not_to include(requested_user)
      end
    end
  end

  describe "#pending_friends" do
    subject(:user) { create(:user) }

    let(:other_user) { create(:user) }

    context "when the users share an accepted request" do
      before do
        create(:friend_request, sender: user, receiver: other_user, accepted: true)
      end

      it "returns a relation object not including the user's friend" do
        expect(user.pending_friends).not_to include(other_user)
      end
    end

    context "when the users share an unaccepted request" do
      before do
        create(:friend_request, sender: user, receiver: other_user)
      end

      it "returns a relation object including the other user" do
        expect(user.pending_friends).to include(other_user)
      end
    end
  end
end
