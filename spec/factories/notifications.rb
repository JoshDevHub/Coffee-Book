# == Schema Information
#
# Table name: notifications
#
#  id            :bigint           not null, primary key
#  read_status   :boolean          default(FALSE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  friendship_id :bigint           not null
#  user_id       :bigint           not null
#
# Indexes
#
#  index_notifications_on_friendship_id  (friendship_id)
#  index_notifications_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (friendship_id => friendships.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :notification do
    user { create(:user) }
    friendship { create(:friendship, receiver: user) }
    read_status { false }
  end
end
