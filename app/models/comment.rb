# == Schema Information
#
# Table name: comments
#
#  id           :bigint           not null, primary key
#  body         :text
#  likes_count  :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  commenter_id :bigint           not null
#  post_id      :bigint
#
# Indexes
#
#  index_comments_on_commenter_id  (commenter_id)
#  index_comments_on_post_id       (post_id)
#
# Foreign Keys
#
#  fk_rails_...  (commenter_id => users.id)
#
class Comment < ApplicationRecord
  include Notify

  MIN_LENGTH = 3
  MAX_LENGTH = 300

  belongs_to :post, counter_cache: true
  belongs_to :commenter, class_name: "User"

  has_many :likes, as: :likeable, dependent: :destroy
  has_many :notifications, as: :notifiable, dependent: :destroy

  validates :body, presence: true, length: { in: MIN_LENGTH..MAX_LENGTH }

  delegate :url_helpers, to: "Rails.application.routes"
  delegate :name, to: :commenter, prefix: :commenter

  private

  def notification_action
    "commented on your post."
  end

  def notification_path
    url_helpers.post_path(post.id)
  end
end
