FactoryBot.define do
  factory :article_comment do
    body { "MyString" }
    user { nil }
    article { nil }
  end
end
