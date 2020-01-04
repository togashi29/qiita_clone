FactoryBot.define do
  factory :article_comment do
    body { Faker::Lorem.sentence }
    user
    article
  end
end
