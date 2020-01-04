class ArticleComment < ApplicationRecord
  belongs_to :user
  belongs_to :article

  validates :body, presence: true
end
