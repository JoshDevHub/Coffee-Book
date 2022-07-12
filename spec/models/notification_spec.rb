# == Schema Information
#
# Table name: notifications
#
#  id            :bigint           not null, primary key
#  read_status   :boolean          default(FALSE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  friendship_id :bigint           not null
#  user_id       :bigint           not null
#
# Indexes
#
#  index_notifications_on_friendship_id  (friendship_id)
#  index_notifications_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (friendship_id => friendships.id)
#  fk_rails_...  (user_id => users.id)
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
