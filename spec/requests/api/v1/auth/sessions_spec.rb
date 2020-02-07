require "rails_helper"

RSpec.describe "Api::V1::Auth::Sessions", type: :request do
  describe "POST /api/v1/auth/sign_in" do
    subject { post(api_v1_user_session_path, params: params) }

    let(:user) { create(:user) }

    describe "正常系のテスト" do
      context "登録済ユーザーの情報を送った時" do
        let(:params) { { "email": user.email, "password": user.password } }

        it "ログインしてトークン情報が取得できる" do
          subject
          header = response.header
          expect(header["access-token"]).to be_present
          expect(header["client"]).to be_present
          expect(header["expiry"]).to be_present
          expect(header["uid"]).to be_present
          expect(response).to have_http_status(:ok)
        end
      end
    end

    describe "異常系のテスト" do
      context "emailが誤っている場合" do
        let(:params) { { "email": Faker::Internet.email, "password": user.password } }

        it "ログイン出来ない" do
          subject
          res = JSON.parse(response.body)
          expect(res["errors"]).to include "Invalid login credentials. Please try again."
        end
      end

      context "passwordが誤っている場合" do
        let(:params) { { "email": user.email, "password": Faker::Internet.password(min_length: 6, max_length: 128) } }

        it "ログイン出来ない" do
          subject
          res = JSON.parse(response.body)
          expect(res["errors"]).to include "Invalid login credentials. Please try again."
        end
      end
    end
  end

  describe "DELETE /api/v1/auth/sign_out" do
    subject { delete(destroy_api_v1_user_session_path, headers: headers) }

    context "ユーザーがログインしているとき" do
      let(:headers) { current_user.create_new_auth_token }
      let(:current_user) { create(:user) }

      it "ログアウトしトークン情報が削除される" do
        subject
        header = response.header
        expect(header["access-token"]).to be nil
        expect(header["client"]).to be nil
        expect(header["expiry"]).to be nil
        expect(header["uid"]).to be nil
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
