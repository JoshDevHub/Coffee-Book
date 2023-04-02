# == Schema Information
#
# Table name: notifications
#
#  id              :bigint           not null, primary key
#  message         :string
#  notifiable_type :string           not null
#  read_status     :boolean          default(FALSE)
#  url             :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  notifiable_id   :bigint           not null
#  user_id         :bigint           not null
#
# Indexes
#
#  index_notifications_on_notifiable  (notifiable_type,notifiable_id)
#  index_notifications_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"

RSpec.describe Notification do
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

  describe "#link?" do
    context "when the notification url is a url string" do
      subject(:notif_with_url) { create(:notification, url: localhost) }

      let(:localhost) { "http://localhost:3000" }

      it "returns true" do
        expect(notif_with_url).to be_link
      end
    end

    context "when the notification url is an empty string" do
      subject(:notif_no_url) { create(:notification, url: "") }

      it "returns false" do
        expect(notif_no_url).not_to be_link
      end
    end
  end
end
