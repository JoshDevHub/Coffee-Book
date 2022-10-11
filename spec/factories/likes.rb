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
FactoryBot.define do
  factory :like do
    likeable { nil }
    liker { create(:user, :liking_user) }
  end
end
