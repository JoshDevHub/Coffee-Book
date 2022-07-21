# == Schema Information
#
# Table name: profiles
#
#  id         :bigint           not null, primary key
#  birthday   :date
#  gender     :integer
#  location   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_profiles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"

RSpec.describe Profile, type: :model do
  describe "#complete?" do
    context "when the profile is complete" do
      subject(:complete_profile) { create(:profile) }

      it "returns true" do
        expect(complete_profile).to be_complete
      end
    end

    context "when the profile is not complete" do
      subject(:incomplete_profile) { create(:profile, :incomplete) }

      it "returns false" do
        expect(incomplete_profile).not_to be_complete
      end
    end
  end
end
