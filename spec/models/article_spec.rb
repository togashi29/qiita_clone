require 'rails_helper'

RSpec.describe Article, type: :model do
  describe "正常系のテスト" do
    context "title,bodyが入力されている時" do
      it "記事が作られる" do
        article = build(:article)
        expect(article).to be_valid
      end
    end
  end

  describe "異常系のテスト" do
    context "titleが入力されていない時" do
      it "エラーする" do
        article = build(:article, title: nil)
        article.valid?
        expect(article.errors.messages[:title]).to include "can't be blank"
      end
    end

    context "bodyが入力されていない時" do
      it "エラーする" do
        article = build(:article, body: nil)
        article.valid?
        expect(article.errors.messages[:body]).to include "can't be blank"
      end
    end
  end

end
