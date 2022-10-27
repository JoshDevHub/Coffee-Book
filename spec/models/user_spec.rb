# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  last_name              :string
#  provider               :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  uid                    :string
#  username               :string           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#
require "rails_helper"

RSpec.describe User, type: :model do
  describe "::index_for" do
    let(:current_user) { create(:user) }

    before do
      create(:user, first_name: "Dummy", last_name: "User", username: "dummy_user")
      create(:user, first_name: "Dummy", last_name: "User", username: "dummy_user2")
      create(:user, first_name: "Dummy", last_name: "User", username: "dummy_user3")
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
        create(:user, first_name: "Jimmy", last_name: "Carter", username: "jimmy_carter")
        create(:user, first_name: "Carter", last_name: "Hadley", username: "carter_hadley")
      end

      let(:query) { "Carter" }
      let(:lowercase_query) { "carter" }

      it "matches against users' first and last names" do
        expect(described_class.search_by_name(query).size).to eq 2
      end

      it "is not case sensitive" do
        expect(described_class.search_by_name(lowercase_query).size).to eq 2
      end

      it "does not return an unmatched user" do
        unmatched = create(:user, first_name: "Chris", last_name: "Ham", username: "chris_ham")
        expect(described_class.search_by_name(query)).not_to include unmatched
      end
    end

    context "when given two names" do
      before do
        create(:user, first_name: "Josh", last_name: "Smith", username: "joshy")
        create(:user, first_name: "Corey", last_name: "Hart", username: "coray")
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

  describe "#save" do
    it "creates a profile for the user" do
      expect(create(:user).profile).to be_a Profile
    end
  end

  describe "#friends" do
    subject(:user) { create(:user) }

    context "when the users share an accepted request" do
      let(:users_friend) { create(:user, :friend) }

      before do
        create(:friendship, sender: user, receiver: users_friend, accepted: true)
      end

      it "returns a relation object including the user's friend" do
        expect(user.friends).to include(users_friend)
      end
    end

    context "when the users do not share a request" do
      it "returns a relation object not including the user who isn't a friend" do
        not_users_friend = create(:user, :john_doe)
        expect(user.friends).not_to include(not_users_friend)
      end
    end

    context "when the users share an unaccepted request" do
      it "does not include the other user if the request isn't accepted" do
        requested_user = create(:user, :friend)
        create(:friendship, sender: user, receiver: requested_user, accepted: false)
        expect(user.friends).not_to include(requested_user)
      end
    end
  end

  describe "#friends_awaiting_acceptance" do
    subject(:user) { create(:user) }

    let(:other_user) { create(:user, :friend) }

    context "when the users share an accepted request" do
      before do
        create(:friendship, sender: user, receiver: other_user, accepted: true)
      end

      it "returns a relation object not including the user's friend" do
        expect(user.friends_awaiting_acceptance).not_to include(other_user)
      end
    end

    context "when the users share an unaccepted request" do
      before do
        create(:friendship, sender: user, receiver: other_user)
      end

      it "returns a relation object including the other user" do
        expect(user.friends_awaiting_acceptance).to include(other_user)
      end
    end
  end

  describe "#read_notifications" do
    subject(:user) { create(:user) }

    let(:notif_count) { 5 }

    before do
      create_list(:notification, notif_count, user:)
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
