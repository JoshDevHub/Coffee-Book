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
FactoryBot.define do
  factory :notification do
    user { create(:user) }
    notifiable { create(:friendship) }
    message { "message" }
    url { "url" }
    read_status { false }
  end
end
