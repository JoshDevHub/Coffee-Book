require "rails_helper"

RSpec.describe FriendRequest, type: :model do
  describe "#confirm" do
    let(:sender) { create(:user) }
    let(:receiver) { create(:user) }

    context "when the request is unaccepted" do
      subject(:unaccepted_request) { described_class.new(sender: sender, receiver: receiver) }

      it "changes the accepted attribute to true" do
        expect { unaccepted_request.confirm }.to change(unaccepted_request, :accepted).to true
      end
    end

    context "when the request is already accepted" do
      subject(:accepted_request) { described_class.new(sender: sender, receiver: receiver, accepted: true) }

      it "keeps the accepted attribute true" do
        expect { accepted_request.confirm }.not_to change(accepted_request, :accepted).from true
      end
    end
  end
end
