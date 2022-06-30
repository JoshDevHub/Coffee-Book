# == Schema Information
#
# Table name: notifications
#
#  id                :bigint           not null, primary key
#  user_id           :bigint           not null
#  friend_request_id :bigint           not null
#  read_status       :boolean          default(FALSE)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
require "rails_helper"

RSpec.describe Notification, type: :model do
  describe "#mark_as_read" do
    context "when the notification is unread" do
      subject(:unread_notif) { create(:notification) }

      it "changes the read_status attribute to true" do
        expect { unread_notif.mark_as_read }.to change(unread_notif, :read_status).to true
      end

      it "saves the new read_status attribute" do
        unread_notif.mark_as_read
        expect(unread_notif.saved_changes).to include("read_status")
      end
    end

    context "when the notification is already read" do
      subject(:read_notif) { create(:notification, read_status: true) }

      it "keeps the read_status attribute true" do
        expect { read_notif.mark_as_read }.not_to change(read_notif, :read_status).from true
      end
    end
  end
end
