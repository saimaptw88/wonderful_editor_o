require "rails_helper"

RSpec.describe "Api::V1::Articles::Drafts", type: :request do
  # index
  describe "GET /api/v1/articles/drafts" do
    subject { get(api_v1_articles_drafts_path, headers: headers) }

    # 記事作成
    before do
      @user = create(:user)
      create(:article, user_id: @user.id, status: "draft")
      create(:article, user_id: @user.id, updated_at: 1.days.ago)
      create(:article, user_id: @user.id, updated_at: 2.days.ago)
    end

    # 認証用情報
    let(:headers) { @user.create_new_auth_token }

    it "認証が通っている" do
      subject
      expect(response).to have_http_status(:success)
    end

    it "draftの記事のみ取得できている" do
      subject
      res = JSON.parse(response.body)
      expect(res.map {|i| i["status"] }).to eq Article.draft.map {|j| j[:status] }
    end
  end

  # show
  describe "GET  /api/v1/articles/draft/:id" do
    subject { get(api_v1_articles_draft_path(article_id), headers: headers) }

    before do
      @user = create(:user)
      create_list(:article, 10, user_id: @user.id)
      create(:article, user_id: @user.id, status: "draft")
    end

    # 認証情報
    let(:headers) { @user.create_new_auth_token }

    # 記事一覧の中からdraftかつ、article.idが若いものを送信
    let(:article_id) { @user.articles.draft.first.id }

    it "認証に成功し、正常なレスポンスが返ってくる" do
      subject
      expect(response).to have_http_status(:success)
    end

    it "認証が成功し、draft記事が返ってくる" do
      subject
      res = JSON.parse(response.body)
      expect(res["status"]).to eq "draft"
    end
  end
end
