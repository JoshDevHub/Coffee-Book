# == Schema Information
#
# Table name: friendships
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
#  index_friends                     (LEAST(sender_id, receiver_id), GREATEST(sender_id, receiver_id)) UNIQUE
#  index_friendships_on_receiver_id  (receiver_id)
#  index_friendships_on_sender_id    (sender_id)
#
# Foreign Keys
#
#  fk_rails_...  (receiver_id => users.id)
#  fk_rails_...  (sender_id => users.id)
#
FactoryBot.define do
  factory :friendship do
    sender { create(:user, :friend_initiater) }
    receiver { create(:user, :friend) }
    accepted { false }
  end
end
