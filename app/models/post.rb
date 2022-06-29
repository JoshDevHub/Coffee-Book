class Post < ApplicationRecord
  belongs_to :user

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy

  validates :body, presence: true

  def self.timeline_for(user)
    where(user: user).or(where(user: user.friends))
  end
end
