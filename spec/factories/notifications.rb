FactoryBot.define do
  factory :notification do
    user { create(:user) }
    friend_request { create(:friend_request, receiver: user) }
    read_status { false }
  end
end
