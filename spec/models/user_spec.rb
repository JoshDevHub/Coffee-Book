# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  last_name              :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
require "rails_helper"

RSpec.describe User, type: :model do
  describe "::index_for" do
    let(:current_user) { create(:user) }

    before do
      create_list :user, 3
    end

    it "returns an ActiveRelation object with 3 users" do
      expect(described_class.index_for(current_user).size).to eq 3
    end

    it "does not return an ActiveRelation object including the given user" do
      expect(described_class.index_for(current_user)).not_to include current_user
    end
  end

  describe "::search_by_name" do
    context "when given a single name" do
      before do
        create(:user, first_name: "Jimmy", last_name: "Carter")
        create(:user, first_name: "Carter", last_name: "Hadley")
      end

      let(:query) { "Carter" }

      it "matches against users' first and last names" do
        expect(described_class.search_by_name(query).size).to eq 2
      end

      it "does not return an unmatched user" do
        unmatched = create(:user, first_name: "Chris", last_name: "Ham")
        expect(described_class.search_by_name(query)).not_to include unmatched
      end
    end

    context "when given two names" do
      before do
        create(:user, first_name: "Josh", last_name: "Smith")
        create(:user, first_name: "Corey", last_name: "Hart")
      end

      let(:query) { "Corey Smith" }

      it "matches against the users' first and last names" do
        expect(described_class.search_by_name(query).size).to eq 2
      end

      it "does not return an unmatched user" do
        unmatched = create(:user, first_name: "Smith", last_name: "Corey")
        expect(described_class.search_by_name(query)).not_to include unmatched
      end
    end
  end

  describe "#send_friend_request" do
    subject(:request_sender) { create(:user) }

    let(:receiver) { create(:user) }

    context "when no request exists between the two users" do
      it "creates a new Friendship record" do
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
        create(:friendship, sender: request_sender, receiver: receiver)
      end

      it "does not create a new Friendship record" do
        expect { request_sender.send_friend_request(receiver) }.not_to change(Friendship, :count)
      end
    end
  end

  describe "#friends" do
    subject(:user) { create(:user) }

    context "when the users share an accepted request" do
      let(:users_friend) { create(:user) }

      before do
        create(:friendship, sender: user, receiver: users_friend, accepted: true)
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
        create(:friendship, sender: user, receiver: requested_user, accepted: false)
        expect(user.friends).not_to include(requested_user)
      end
    end
  end

  describe "#pending_friends" do
    subject(:user) { create(:user) }

    let(:other_user) { create(:user) }

    context "when the users share an accepted request" do
      before do
        create(:friendship, sender: user, receiver: other_user, accepted: true)
      end

      it "returns a relation object not including the user's friend" do
        expect(user.pending_friends).not_to include(other_user)
      end
    end

    context "when the users share an unaccepted request" do
      before do
        create(:friendship, sender: user, receiver: other_user)
      end

      it "returns a relation object including the other user" do
        expect(user.pending_friends).to include(other_user)
      end
    end
  end

  describe "#read_notifications" do
    subject(:user) { create(:user) }

    let(:notif_count) { 5 }

    before do
      build_list(:notification, notif_count, user:)
    end

    it "changes unread notification count from 5 to 0" do
      expect { user.read_notifications }
        .to change(user.notifications.where(read_status: false), :count)
        .from(notif_count)
        .to(0)
    end
  end

  describe "#unread_notifications?" do
    subject(:user) { create(:user) }

    context "when the user has unread notifications" do
      before do
        create(:notification, user:, read_status: false)
      end

      it "returns true" do
        expect(user).to be_unread_notifications
      end
    end

    context "when the user has no unread notifications" do
      before do
        create(:notification, user:)
        user.read_notifications
      end

      it "returns false" do
        expect(user).not_to be_unread_notifications
      end
    end

    context "when the user has no notifications" do
      it "returns false" do
        expect(user).not_to be_unread_notifications
      end
    end
  end
end
