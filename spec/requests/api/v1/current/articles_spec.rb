require "rails_helper"

RSpec.describe "Api::V1::Current::Articles", type: :request do
  describe "GET /api/v1/current/articles" do
    subject { get(api_v1_current_articles_path, headers: headers) }

    let(:current_user) { create(:user) }
    let(:headers) { current_user.create_new_auth_token }

    context "自分が書いた公開記事があるとき" do
      before do
        create_list(:article, 5, status: "published", user: current_user)
        create_list(:article, 10, user: current_user)
      end

      it "自分が書いた公開記事の一覧を取得できる" do
        subject
        res = JSON.parse(response.body)

        expect(res.length).to eq 5
        expect(res[0].keys).to eq ["id", "title", "body", "updated_at", "status", "user"]
        expect(res[0]["user"].keys).to eq ["id", "name"]
        expect(response).to have_http_status(:ok)
      end
    end
  end
end