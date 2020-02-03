require "rails_helper"

RSpec.describe "Api::V1::Articles", type: :request do
  describe "GET /api/v1/articles" do
    subject { get(api_v1_articles_path) }

    before do
      create_list(:article, 3)
    end

    it "記事の一覧が取得できる" do
      subject
      res = JSON.parse(response.body)

      expect(res.length).to eq 3
      expect(res[0].keys).to eq ["id", "title", "body", "updated_at", "user"]
      expect(res[0]["user"].keys).to eq ["id", "name"]
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /api/v1/articles/:id" do
    subject { get(api_v1_article_path(article_id)) }

    describe "正常系のテスト" do
      context "指定したidの記事が存在する場合" do
        let(:article) { create(:article) }
        let(:article_id) { article.id }

        it "指定したidの記事が取得できる" do
          subject
          res = JSON.parse(response.body)

          expect(res["id"]).to eq article.id
          expect(res["title"]).to eq article.title
          expect(res["body"]).to eq article.body
          expect(res["updated_at"]).to be_present
          expect(res["user"]["id"]).to eq article.user.id
          expect(res["user"]["name"]).to eq article.user.name
          expect(response).to have_http_status(:ok)
        end
      end
    end

    describe "異常系のテスト" do
      context "指定したidの記事が存在しない場合" do
        let(:article_id) { 10000 }

        it "記事が見つからない" do
          expect { subject }.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end
  end

  describe "POST /api/v1/articles" do
    subject { post(api_v1_articles_path, params: params, headers: headers) }

    let(:params) { { article: attributes_for(:article) } }
    let(:current_user) { create(:user) }
    let(:headers) { current_user.create_new_auth_token }

    it "記事が作成できる" do
      expect { subject }.to change { current_user.articles.count }.by(1)
      res = JSON.parse(response.body)
      expect(res["title"]).to eq params[:article][:title]
      expect(res["body"]).to eq params[:article][:body]
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /api/v1/articles/:id" do
    subject { patch(api_v1_article_path(article.id), params: params, headers: headers) }

    let(:params) { { article: { body: Faker::Quote.matz, created_at: Time.current } } }
    let(:current_user) { create(:user) }
    let(:headers) { current_user.create_new_auth_token }

    describe "正常系のテスト" do
      context "自身の作成記事を更新しようとする場合" do
        let(:article) { create(:article, user: current_user) }

        it "更新できる" do
          expect { subject }.to change { Article.find(article.id).body }.from(article.body).to(params[:article][:body]) &
                                not_change { Article.find(article.id).title } &
                                not_change { Article.find(article.id).created_at }
          expect(response).to have_http_status(:ok)
        end
      end
    end

    describe "異常系のテスト" do
      context "他userの作成記事を更新しようとする場合" do
        let(:article) { create(:article) }

        it "更新できない" do
          expect { subject }.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end
  end

  describe "DELETE /api/v1/articles/:id" do
    subject { delete(api_v1_article_path(article.id), headers: headers) }

    let(:current_user) { create(:user) }
    let(:headers) { current_user.create_new_auth_token }

    describe "正常系のテスト" do
      context "自身の作成記事を削除しようとする場合" do
        let!(:article) { create(:article, user: current_user) }

        it "削除できる" do
          expect { subject }.to change { current_user.articles.count }.by(-1)
          expect(response).to have_http_status(:no_content)
        end
      end
    end

    describe "異常系のテスト" do
      context "他userの作成記事を削除しようとする場合" do
        let!(:article) { create(:article) }

        it "削除できない" do
          expect { subject }.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end
  end
end
