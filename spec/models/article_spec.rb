require "rails_helper"

RSpec.describe Article, type: :model do
  describe "正常系のテスト" do
    context "title,bodyが入力されている時" do
      it "記事が作られる" do
        article = build(:article)
        expect(article).to be_valid
      end
    end

    describe "statusを指定した記事の取得" do
      describe "下書き記事の取得" do
        subject { Article.draft }

        context "statusが下書きである記事があるとき" do
          before do
            create_list(:article, 5)
          end

          it "下書き記事が取得できる" do
            expect(subject.count).to eq 5
            expect(subject[0].status).to eq "draft"
          end
        end
      end

      describe "公開記事の取得" do
        subject { Article.published }

        context "statusが公開である記事があるとき" do
          before do
            create_list(:article, 10, status: "published")
          end

          it "公開記事が取得できる" do
            expect(subject.count).to eq 10
            expect(subject[0].status).to eq "published"
          end
        end
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
