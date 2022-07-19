# == Schema Information
#
# Table name: profiles
#
#  id         :bigint           not null, primary key
#  birthday   :date
#  country    :string
#  gender     :integer
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
  GENDERS = { male: 0, female: 1, nonbinary: 3 }.freeze

  enum gender: GENDERS

  belongs_to :user

  def complete?
    attributes.values.all?
  end
end
