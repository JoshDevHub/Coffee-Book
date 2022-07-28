require "rails_helper"

RSpec.describe UsersHelper do
  describe "gravatar_for" do
    let(:user) do
      create(:user, first_name: first, last_name: last, email: "test@email.com")
    end
    let(:first) { "first" }
    let(:last) { "last" }

    it "returns an image tag with a gravatar URL for the given user" do
      # MD5 hash of the user's email
      email_hash = "93942e96f5acd83e2e047ad8fe03114d"

      expected_gravatar_url = "http://secure.gravatar.com/avatar/#{email_hash}"
      expect(helper.gravatar_url_for(user)).to eq expected_gravatar_url
    end
  end
end
