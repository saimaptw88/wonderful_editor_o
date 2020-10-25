require "rails_helper"

RSpec.describe "Api::V1::Current::Articles", type: :request do
  # index
  describe "GET  /api/v1/current/articles" do
    subject { get(api_v1_current_articles_path, headers: headers) }

    before do
      @user = create(:user)
      create(:article, status: "published", user_id: @user.id)
      create(:article, status: "published", user_id: @user.id, updated_at: 1.days.ago)
      create(:article, status: "published", user_id: @user.id, updated_at: 2.days.ago)
      create_list(:article, 3, user_id: @user.id)
      create_list(:article, 6)
    end

    let(:headers) { @user.create_new_auth_token }

    it "正常なレスポンスが返ってくる" do
      subject
      expect(response).to have_http_status(:success)
    end

    it "published記事のみ返ってくる" do
      subject
      res = JSON.parse(response.body)
      expect(res.map {|i| i["status"] }).to eq @user.articles.published.map {|j| j[:status] }
    end

    it "user_idがログインしているユーザーのものである" do
      subject
      res = JSON.parse(response.body)
      expect(res.map {|i| i["user_id"] }).to eq @user.articles.published.map {|j| j[:user_id] }
    end

    it "取得した記事が更新順で返ってくる" do
      subject
      res = JSON.parse(response.body)
      expect(res.map {|i| i["id"] }).to eq @user.articles.published.order(updated_at: :desc).map {|j| j[:id] }
    end
  end
end
