FactoryBot.define do
  factory :team do
    association :customer
    name {  Faker::Lorem.characters(number: 5) }
    address { Faker::Lorem.characters(number: 10) }
    introduction { Faker::Lorem.characters(number: 20) }
  end
end