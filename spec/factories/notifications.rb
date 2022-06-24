FactoryBot.define do
  factory :notification do
    user { nil }
    request { nil }
    read_status { false }
  end
end
