require "rails_helper"

RSpec.describe "Api::V1::Auth::Registrations", type: :request do
  describe "POST api/v1/auth/resgistrations#create" do
    subject { post(api_v1_user_registration_path, params: params) }

    context "リクエストが正しい" do
      let(:params) { attributes_for(:user) }
      it "新規登録の成功" do
        expect { subject }.to change { User.count }.by(1)
        # expect(response).to have_http_status(:ok)
        # res = JSON.parse(response.body)
        # expect( res["data"]["email"] ).to eq User.find(res["data"]["id"]).email
      end
    end

    context "nameの入力がない" do
      let(:params) { attributes_for(:user, name: nil) }

      it "エラー" do
        expect { subject }.to change { User.count }.by(0)
        # res = JSON.parse(response.body)
        # expect(res["errors"]["name"][0]).to eq "can't be blank"
        # expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "emailの入力がない" do
      let(:params) { attributes_for(:user, email: nil) }
      it "エラー" do
        expect { subject }.to change { User.count }.by(0)
        # res = JSON.parse(response.body)
        # expect(res["errors"]["email"][0]).to eq "can't be blank"
        # expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "passwordの入力がない" do
      let(:params) { attributes_for(:user, password: nil) }
      it "エラー" do
        expect { subject }.to change { User.count }.by(0)
        # res = JSON.parse(response.body)
        # expect(res["errors"]["password"]).to eq ["can't be blank"]
        # expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
