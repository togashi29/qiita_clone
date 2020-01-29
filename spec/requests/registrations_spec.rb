require 'rails_helper'

RSpec.describe "Api::V1::Auth::Registrations", type: :request do
  describe "POST /api/v1/auth" do
    subject { post(api_v1_user_registration_path, params: params) }
    let(:params) { attributes_for(:user) }

    it "ユーザーが作成されトークン情報が取得できる" do
      subject
      header = response.header
      expect(header["access-token"]).to be_present
      expect(header["client"]).to be_present
      expect(header["expiry"]).to be_present
      expect(header["uid"]).to be_present
      expect(response).to have_http_status(200)
    end
  end
end
