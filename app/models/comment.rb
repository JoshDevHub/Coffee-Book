# == Schema Information
#
# Table name: comments
#
#  id               :bigint           not null, primary key
#  body             :text
#  commentable_type :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  commentable_id   :bigint           not null
#  commenter_id     :bigint           not null
#
# Indexes
#
#  index_comments_on_commentable   (commentable_type,commentable_id)
#  index_comments_on_commenter_id  (commenter_id)
#
# Foreign Keys
#
#  fk_rails_...  (commenter_id => users.id)
#
class Comment < ApplicationRecord
  include Notify

  NOTIFICATION_ACTION = "commented on your post.".freeze
  NOTIFICATION_PATH = "comment_path".freeze

  belongs_to :commentable, polymorphic: true
  belongs_to :commenter, class_name: "User"

  has_many :likes, as: :likeable, dependent: :destroy
  has_many :notifications, as: :notifiable, dependent: :destroy

  validates :body, presence: true
end
