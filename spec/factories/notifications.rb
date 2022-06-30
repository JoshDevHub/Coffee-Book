# == Schema Information
#
# Table name: notifications
#
#  id                :bigint           not null, primary key
#  user_id           :bigint           not null
#  friend_request_id :bigint           not null
#  read_status       :boolean          default(FALSE)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
FactoryBot.define do
  factory :notification do
    user { create(:user) }
    friend_request { create(:friend_request, receiver: user) }
    read_status { false }
  end
end
