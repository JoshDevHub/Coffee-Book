# == Schema Information
#
# Table name: profiles
#
#  id         :bigint           not null, primary key
#  birthday   :date
#  country    :string
#  gender     :integer
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
    country { "MyString" }
    user { nil }
  end
end
