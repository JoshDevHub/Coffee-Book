# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  last_name              :string
#  provider               :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  uid                    :string
#  username               :string           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#
FactoryBot.define do
  factory :user do
    first_name { "Test" }
    last_name { "User" }
    password { "testing123" }
    sequence(:email) { |n| "person#{n}@example.com" }
    sequence(:username) { |n| "user_number#{n}" }

    trait :friend_initiater do
      first_name { "Friend" }
      last_name { "Initiater" }
    end

    trait :friend do
      first_name { "Amigo" }
      last_name { "User" }
    end

    trait :author_user do
      first_name { "Post" }
      last_name { "Author" }
    end

    trait :liking_user do
      first_name { "Liking" }
      last_name { "User" }
    end

    trait :comment_user do
      first_name { "Comment" }
      last_name { "Guy" }
    end

    trait :john_doe do
      first_name { "John" }
      last_name { "Doe" }
    end
  end
end
