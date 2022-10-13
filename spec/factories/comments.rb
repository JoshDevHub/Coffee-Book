# == Schema Information
#
# Table name: comments
#
#  id           :bigint           not null, primary key
#  body         :text
#  likes_count  :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  commenter_id :bigint           not null
#  post_id      :bigint
#
# Indexes
#
#  index_comments_on_commenter_id  (commenter_id)
#  index_comments_on_post_id       (post_id)
#
# Foreign Keys
#
#  fk_rails_...  (commenter_id => users.id)
#
FactoryBot.define do
  factory :comment do
    body { "This is a test environment comment." }
    post { create(:post, :for_comment) }
  end
end
