# == Schema Information
#
# Table name: friend_requests
#
#  id          :bigint           not null, primary key
#  sender_id   :bigint           not null
#  receiver_id :bigint           not null
#  accepted    :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :friend_request do
    sender { create(:user) }
    receiver { create(:receiver) }
    accepted { false }
  end
end
