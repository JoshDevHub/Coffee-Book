# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require "faker"

10.times do
  User.create!(
    {
      email: Faker::Internet.email(domain: "example"),
      username: Faker::Internet.username(separators: %w[-]),
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      password: "test123"
    }
  )
end

User.all.each do |user|
  10.times do
    Post.create!(
      {
        author: user,
        body: Faker::Lorem.paragraph(sentence_count: 2)
      }
    )
  end
end
