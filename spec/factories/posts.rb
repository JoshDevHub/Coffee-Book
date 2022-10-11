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
FactoryBot.define do
  factory :post do
    author { create(:user, :author_user) }
    body { "This is a test environment post" }

    trait :for_comment do
      body { "This is a post with a test comment" }
    end
  end
end
