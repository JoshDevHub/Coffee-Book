# == Schema Information
#
# Table name: posts
#
#  id          :bigint           not null, primary key
#  body        :string
#  likes_count :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  author_id   :bigint           not null
#
# Indexes
#
#  index_posts_on_author_id  (author_id)
#
# Foreign Keys
#
#  fk_rails_...  (author_id => users.id)
#
class Post < ApplicationRecord
  belongs_to :author, class_name: "User"

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy

  validates :body, presence: true

  def self.timeline_for(user)
    where(author: user).or(where(author: user.friends)).order(created_at: :desc)
  end

  def total_likes
    likes.count
  end

  def find_like_from(user)
    likes.find_by(liker: user)
  end
end
