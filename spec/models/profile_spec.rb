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

  describe "#age" do
    context "when the birthday has not occured for the given year" do
      subject(:profile) { create(:profile, birthday: "05/10/1990") }

      it "returns the expected age" do
        test_date = "21/07/2022"
        expected_age = 31
        expect(profile.age_at(test_date)).to eq expected_age
      end
    end

    context "when the birthday has happened for the given year" do
      subject(:profile) { create(:profile, birthday: "01/01/2002") }

      it "returns the expected age" do
        test_date = "01/01/2022"
        expected_age = 20
        expect(profile.age_at(test_date)).to eq expected_age
      end
    end

    context "when the birthday is a leap year" do
      subject(:profile) { create(:profile, birthday: "29/02/2004") }

      it "returns the expected age" do
        test_date = "01/03/2022"
        expected_age = 18
        expect(profile.age_at(test_date)).to eq expected_age
      end
    end
  end
end
