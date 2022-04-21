FactoryBot.define do
  factory :activity do
    title { Faker::Lorem.characters(number: 5) }
    content { Faker::Lorem.characters(number: 20) }
    activity_on { Faker::Date.between(from: 2.days.ago, to: Date.today) }
    status { 0 }
  end
end