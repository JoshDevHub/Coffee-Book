# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  body       :string
#  user_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Post < ApplicationRecord
  belongs_to :user

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy

  validates :body, presence: true

  def self.timeline_for(user)
    where(user: user).or(where(user: user.friends)).order(created_at: :desc)
  end

  def total_likes
    likes.count
  end

  def find_like_from(user)
    likes.find_by(user: user)
  end
end
