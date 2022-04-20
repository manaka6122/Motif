FactoryBot.define do
  factory :customer do
    name { Faker::Lorem.characters(number: 5) }
    email { Faker::Internet.email }
    profile { Faker::Lorem.characters(number: 20) }
    password { 'password' }
    password_confirmation { 'password' }
  end
end