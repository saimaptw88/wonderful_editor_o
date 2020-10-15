require "rails_helper"

RSpec.describe "Api::V1::Auth::Sessions", type: :request do
  # ログイン
  describe "POST /api/v1/auth/sessions#creatte" do
    subject { post(api_v1_user_session_path, params: params) }

    # すでに存在するユーザーのパストメアドをhashで渡す
    # let(:params) do
    #   {
    #     user:{
    #       email: "#{user.email}",
    #       password: "#{user.password}"
    #     }
    #   }
    # end

    let(:params) { attributes_for(:user, email: user.email, password: user.password) }

    # emailの分類
    # emailが入力されている
    context "emailが入力されている" do
      # すでに存在するユーザーを作成
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

  # ログアウト
  describe "DELETE /api/v1/auth/sessions#destroy" do
    # ログイン
    subject { delete(destroy_api_v1_user_session_path, headers: headers) }
    # 必要な情報を送信される

    context "必要な情報を送信する" do
      let(:user) { create(:user) }
      let(:headers) { user.create_new_auth_token }
      it "ログアウトに成功し、hhtpレスポンス200を返す" do
        subject
        expect(response).to have_http_status :ok
      end

      it "tokenを削除しログアウトできる" do
        subject
        expect(user.reload.tokens).to be_blank
      end
    end

    context "誤った情報を送信した時" do
      let(:user) { create(:user) }
      let(:headers) do
        {
          "access-token" => "",
          "token-type" => "",
          "client" => "",
          "expiry" => "",
          "uid" => "",
        }
      end
      it "ログインに失敗する" do
        subject
        res = JSON.parse(response.body)
        expect(res["success"]).to eq false
      end
    end
  end
end
