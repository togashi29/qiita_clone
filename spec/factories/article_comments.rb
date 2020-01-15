FactoryBot.define do
  factory :article_comment do
    body { Faker::Quote.most_interesting_man_in_the_world }
    user
    article
  end
end
