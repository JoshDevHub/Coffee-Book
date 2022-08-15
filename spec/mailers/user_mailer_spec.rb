require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "#welcome_email" do
    subject(:mail) { described_class.with(user:).welcome_email }

    let(:user) { instance_double(User, name: "Josh Smith", email: "josh@email.com") }

    it "renders the subject" do
      expect(mail.subject).to eq("Welcome to Coffee Book!")
    end

    it "renders the receiver email" do
      expect(mail.to).to eq([user.email])
    end

    it "renders the sender email" do
      sender = "notifications@example.com"
      expect(mail.from).to eq([sender])
    end
  end
end
