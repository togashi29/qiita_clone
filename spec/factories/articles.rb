FactoryBot.define do
  factory :article do
    title { Faker::Movie.quote }
    body { Faker::Quote.matz }
    status { :draft }
    user
  end
end
