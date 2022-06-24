FactoryBot.define do
  factory :friend_request do
    sender { create(:user) }
    receiver { create(:receiver) }
    accepted { false }
  end
end
