# == Schema Information
#
# Table name: profiles
#
#  id         :bigint           not null, primary key
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
  enum gender: {
    unspecified: 0,
    male: 1,
    female: 2,
    nonbinary: 3
  }

  belongs_to :user

  def complete?
    attributes.values.all?
  end

  def age_at(date)
    ((date.to_time - birthday.to_time) / 1.year.seconds).floor
  end
end
