require 'rails_helper'

RSpec.describe User, type: :model do
  describe "正常系のテスト" do
    context "name, email, passwordが入力されている時" do
      it "ユーザーが作られる" do
        user = build(:user)
        expect(user).to be_valid
      end
    end
  end

  describe "異常系のテスト" do
    describe "nameについて" do
      context "nameが入力されていない時" do
        it "エラーする" do
          user = build(:user, name: nil)
          user.valid?
          expect(user.errors.messages[:name]).to include "can't be blank"
        end
      end
    end

    describe "emailについて" do
      context "emailが入力されていない時" do
        it "エラーする" do
          user = build(:user, email: nil)
          user.valid?
          expect(user.errors.messages[:email]).to include "can't be blank"
        end
      end

      context "同一のemailが存在する時" do
        it "エラーする" do
          create(:user, email: "tsuruoka@example.com")
          user = build(:user, email: "tsuruoka@example.com")
          user.valid?
          expect(user.errors.messages[:email]).to include "has already been taken"
        end
      end

      context "emailに@が含まれない時" do
        it "エラーする" do
          user = build(:user, email: "tsuruokaexample.com")
          user.valid?

          expect(user.errors.messages[:email]).to include "is not an email"
        end
      end
    end

    describe "passwordについて" do
      context "passwordが入力されていない時" do
        it "エラーする" do
          user = build(:user, password: nil)
          user.valid?
          expect(user.errors.messages[:password]).to include "can't be blank"
        end
      end

      context "passwordが5文字以下の時" do
        it "エラーする" do
          user = build(:user, password: "a"*5)
          user.valid?
          expect(user.errors.messages[:password]).to include "is too short (minimum is 6 characters)"
        end
      end

      context "passwordが129文字以上の場合" do
        it "エラーする" do
          user = build(:user, password: "a"*129)
          user.valid?
          expect(user.errors.messages[:password]).to include "is too long (maximum is 128 characters)"
        end
      end
    end
  end

end