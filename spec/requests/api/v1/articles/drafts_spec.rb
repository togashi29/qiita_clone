require "rails_helper"

RSpec.describe "Api::V1::Articles::Drafts", type: :request do
  describe "GET /api/v1/articles/drafts" do
    subject { get(api_v1_articles_drafts_path, headers: headers) }

    let(:current_user) { create(:user) }
    let(:headers) { current_user.create_new_auth_token }

    context "ログインユーザーが作成した下書き記事があるとき" do
      before { create_list(:article, 3, user: current_user) }

      it "下書き記事の一覧が取得できる" do
        subject
        res = JSON.parse(response.body)

        expect(res.length).to eq 3
        expect(res[0].keys).to eq ["id", "title", "body", "updated_at", "status", "user"]
        expect(res[0]["user"].keys).to eq ["id", "name"]
        expect(response).to have_http_status(:ok)
      end
    end
  end
end