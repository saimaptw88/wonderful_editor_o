require "rails_helper"

RSpec.describe "Api::V1::Auth::Sessions", type: :request do
  describe "POST /api/v1/auth/sessions#creatte" do
    subject { post(api_v1_user_session_path, params: params) }

    let(:params) { attributes_for(:user, email: user.email, password: user.password) }

    # emailの分類
    # emailが入力されている
    context "emailが入力されている" do
      let(:user) { create(:user) }

      it "httpレスポンス200を返しログインする" do
        subject
        expect(response).to have_http_status :ok
      end

      it "passwordを満たし、ログインする" do
        subject
        expect(response.has_header?("uid")).to eq(true)
      end

      it "passwordを満たし、ログインする" do
        subject
        expect(response.has_header?("token-type")).to eq(true)
      end

      it "passwordを満たし、ログインする" do
        subject
        expect(response.has_header?("access-token")).to eq(true)
      end
    end

    # emailが入力されていない
    context "emailが入力されていない" do
      let(:user) { create(:user, email: nil) }

      it "ログインに失敗する" do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    # passwordの分類
    # passwordが入力されていない
    context "passwordが入力されていない" do
      let(:user) { create(:user, password: nil) }

      it "ログインに失敗する" do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
