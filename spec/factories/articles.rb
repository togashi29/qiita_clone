FactoryBot.define do
  factory :article do
    title { Faker::Lorem.characters(number: 10) }
    body { Faker::Lorem.paragraph }
    association :user
  end
end
