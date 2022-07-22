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
#  index_friendships_on_receiver_id  (receiver_id)
#  index_friendships_on_sender_id    (sender_id)
#
# Foreign Keys
#
#  fk_rails_...  (receiver_id => users.id)
#  fk_rails_...  (sender_id => users.id)
#
class Friendship < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"

  has_one :notification, dependent: :destroy

  scope :pending, -> { where(accepted: false) }
  scope :confirmed, -> { where(accepted: true) }

  after_create :send_notification

  def confirm
    update(accepted: true)
  end

  def send_notification
    create_notification!(user: receiver)
  end
end
