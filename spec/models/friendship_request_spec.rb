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
end
