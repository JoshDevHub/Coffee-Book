# == Schema Information
#
# Table name: profiles
#
#  id         :bigint           not null, primary key
#  bio        :string
#  birthday   :date
#  gender     :integer
#  location   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_profiles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Profile < ApplicationRecord
  MAX_BIO_LENGTH = 250
  MAX_LOCATION_LENGTH = 30

  GENDERS = {
    unspecified: 0,
    male: 1,
    female: 2,
    nonbinary: 3
  }.freeze

  enum gender: GENDERS

  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_fill: [80, 80]
    attachable.variant :icon, resize_to_fill: [48, 48]
  end

  belongs_to :user

  validates :bio, length: { maximum: MAX_BIO_LENGTH }
  validates :location, length: { maximum: MAX_LOCATION_LENGTH }
  validates :avatar_attachment, photo_filetype: true,
                                unless: -> { avatar_attachment.nil? }

  def complete?
    attributes.values.all?
  end

  def age_at(date)
    ((date.to_time - birthday.to_time) / 1.year.seconds).floor
  end
end
