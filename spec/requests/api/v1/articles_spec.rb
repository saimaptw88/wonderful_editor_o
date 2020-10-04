require "rails_helper"

RSpec.describe "Api::V1::Articles", type: :request do
  # index
  describe "GET /api/v1/articles" do
    subject { get(api_v1_articles_path) }

    before do
      user = FactoryBot.create(:user)
      # インスタンスを作成
      FactoryBot.create_list(:article, 3, user_id: user.id, updated_at: 1.days.ago)
      # FactoryBot.create(:article, user_id: user.id)
      # FactoryBot.create(:article, user_id: user.id, updated_at: 1.days.ago)
      # FactoryBot.create(:article, user_id: user.id, updated_at: 2.days.ago)
    end

    # let!(:article1) { create(:article, updated_at: 2.days.ago) }
    # let!(:article2) { create(:article, updated_at: 1.days.ago) }
    # let!(:article3) { create(:article) }

    # インスタンスが正しく作成され、表示されているかをテスト
    it "記事一覧を取得できる" do
      subject
      # res = JSON.parse(response.body)
      # URLレポンスが正常？
      expect(response).to have_http_status(:ok)
      # # インスタンスが3つ？
      # expect(res.length).to eq 3
      # # 更新順序に並び替えられている？
      # expect(res.map {|d| d["id"] }).to eq [article3.id, article2.id, article1.id]
      # # 取得keyの確認
      # expect(res[0].keys).to eq ["id", "title", "updated_at", "user"]
    end
  end

  # show
  describe "GET /api/v1/articles/:id" do
    subject { get(api_v1_article_path(article_id)) }

    context "指定したidのユーザーが存在しない場合" do
      let(:article_id) { 10_000_000 }

      it "ユーザーが見つからない" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "指定したidのユーザーが存在する場合" do
      let(:article_id) { article.id }
      let(:article) { create(:article) }

      it "記事を返す" do
        subject
        res = JSON.parse(response.body)
        expect(res["id"]).to eq article.id
        # expect(response).to have_http_status(:ok)
      end
    end
  end

  # create
  describe "POST /api/v1/articles" do
    subject { post(api_v1_articles_path, params: params) }

    context "適切なパラメータを送信する" do
      let(:params) { { article: FactoryBot.attributes_for(:article) } }
      let(:current_user) { create(:user) }

      before { allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user) }

      it "記事が作成される" do
        expect { subject }.to change { Article.count }.by(1)
        # res = JSON.parse(response.body)
        # expect(res["body"]).to eq params[:article][:body]
        # expect(res["title"]).to eq params[:article][:title]
        # expect(response).to have_http_status(:ok)
      end
    end

    context "適切出ないパラメータを送信する" do
      it "エラーする" do
      end
    end
  end

  # describe "PATCH(PUT) /api/v1/articles/:id" do
  # end

  # describe "DELETE /api/v1/articles/:id" do
  # end
end
