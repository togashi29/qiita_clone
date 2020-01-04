require 'rails_helper'

RSpec.describe ArticleComment, type: :model do
  describe "正常系のテスト" do
    context "bodyが入力されている時" do
      it "コメントが作られる" do
        article_comment = build(:article_comment)
        expect(article_comment).to be_valid
      end
    end
  end

  describe "異常系のテスト" do
    context "bodyが入力されていない時" do
      it "エラーする" do
        article_comment = build(:article_comment, body: nil)
        article_comment.valid?
        expect(article_comment.errors.messages[:body]).to include "can't be blank"
      end
    end
  end
end
