class FriendRequest < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"

  scope :pending, -> { where(accepted: false) }
  scope :confirmed, -> { where(accepted: true) }

  def confirm
    update(accepted: true)
  end
end
