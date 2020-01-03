class Article < ApplicationRecord
  belongs_to :user
  has_many :article_comments, dependent: :destroy
  has_many :article_likes, dependent: :destroy
end
