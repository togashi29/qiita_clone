FactoryBot.define do
  factory :article do
    title { Faker::Movie.quote }
    body { Faker::Quote.matz }
    status { :draft }
    user

    trait :draft do
      status { :draft }
    end

    trait :published do
      status { :published }
    end
  end
end
