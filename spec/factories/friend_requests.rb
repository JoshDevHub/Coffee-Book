# == Schema Information
#
# Table name: friend_requests
#
#  id          :bigint           not null, primary key
#  accepted    :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  receiver_id :bigint           not null
#  sender_id   :bigint           not null
#
# Indexes
#
#  index_friend_requests_on_receiver_id  (receiver_id)
#  index_friend_requests_on_sender_id    (sender_id)
#
# Foreign Keys
#
#  fk_rails_...  (receiver_id => users.id)
#  fk_rails_...  (sender_id => users.id)
#
FactoryBot.define do
  factory :friend_request do
    sender { create(:user) }
    receiver { create(:receiver) }
    accepted { false }
  end
end
