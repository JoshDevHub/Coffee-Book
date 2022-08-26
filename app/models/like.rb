# == Schema Information
#
# Table name: likes
#
#  id            :bigint           not null, primary key
#  likeable_type :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  likeable_id   :bigint           not null
#  liker_id      :bigint           not null
#
# Indexes
#
#  index_likes_on_likeable  (likeable_type,likeable_id)
#  index_likes_on_liker_id  (liker_id)
#
# Foreign Keys
#
#  fk_rails_...  (liker_id => users.id)
#
class Like < ApplicationRecord
  include Notify

  belongs_to :likeable, polymorphic: true, counter_cache: :likes_count
  belongs_to :liker, class_name: "User"

  has_many :notifications, as: :notifiable, dependent: :destroy

  delegate :url_helpers, to: "Rails.application.routes"

  private

  def notification_action
    "liked your #{likeable_type.downcase}."
  end

  def notification_path
    resource = case likeable_type
               when "Post" then likeable
               when "Comment" then likeable.commentable
               end
    url_helpers.post_path(resource)
  end
end
