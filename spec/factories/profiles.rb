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
FactoryBot.define do
  factory :profile do
    birthday { "2022-07-11" }
    gender { 1 }
    location { "MyString" }
    user { nil }

    trait :incomplete do
      birthday { nil }
      gender { nil }
      location { nil }
      user { create(:user) }
    end
  end
end
