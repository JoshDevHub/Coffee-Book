require "rails_helper"

describe ProfileDecorator do
  describe "#display_gender" do
    subject(:profile_decorator) { described_class.new(profile) }

    context "when the field is not nil" do
      let(:profile) { instance_double(Profile, gender: "female") }

      it "returns gender field capitalized, labeled, and wrapped in li tags" do
        expected_output = "<li>Gender: Female</li>"
        expect(profile_decorator.display_gender).to eq(expected_output)
      end
    end

    context "when the field is nil" do
      let(:profile) { instance_double(Profile, gender: nil) }

      it "returns an empty string" do
        expect(profile_decorator.display_gender).to eq ""
      end
    end
  end

  describe "#display_age" do
    subject(:profile_decorator) { described_class.new(profile) }

    context "when the field is not nil" do
      let(:profile) { instance_double(Profile, age_at: 31, birthday: "date string") }

      it "returns the age with a label and wrapped in li tags" do
        expected_output = "<li>Age: 31</li>"
        expect(profile_decorator.display_age).to eq(expected_output)
      end
    end

    context "when the field is nil" do
      let(:profile) { instance_double(Profile, age_at: 31, birthday: nil) }

      it "returns an empty string" do
        expect(profile_decorator.display_age).to eq ""
      end
    end
  end

  describe "#display_location" do
    subject(:profile_decorator) { described_class.new(profile) }

    context "when the field is not nil" do
      let(:profile) { instance_double(Profile, location: "America") }

      it "returns the location with a label and wrapped in li tags" do
        expected_output = "<li>Location: America</li>"
        expect(profile_decorator.display_location).to eq(expected_output)
      end
    end

    context "when the field is nil" do
      let(:profile) { instance_double(Profile, location: nil) }

      it "returns an empty string" do
        expect(profile_decorator.display_location).to eq ""
      end
    end
  end
end
