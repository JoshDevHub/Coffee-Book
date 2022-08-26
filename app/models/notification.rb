# == Schema Information
#
# Table name: notifications
#
#  id              :bigint           not null, primary key
#  message         :string
#  notifiable_type :string           not null
#  read_status     :boolean          default(FALSE)
#  url             :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  notifiable_id   :bigint           not null
#  user_id         :bigint           not null
#
# Indexes
#
#  index_notifications_on_notifiable  (notifiable_type,notifiable_id)
#  index_notifications_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  scope :most_recent, -> { order(created_at: :desc) }

  def mark_as_read
    update(read_status: true)
  end
end
