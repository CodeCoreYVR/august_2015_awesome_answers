# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
100.times do
  title      = Faker::Company.bs
  body       = Faker::Lorem.paragraph
  view_count = rand(100)
  created_at = Time.now - (rand(30)).days
  Question.create({title:      title,
                   body:       body,
                   view_count: view_count,
                   created_at: created_at})
end

print Cowsay::say("Created a 100 questions")
