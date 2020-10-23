# article_controllerのメソッド操作時はユーザー認証が必要
# 問題はどのタイミングでユーザー認証を行うか？
# 候補1：articles_controllerのhttpリクエスト時
# 　-> articles_controllerのメソッド実行時のリクエストに認証情報を送信
# 候補2：articles_controllerのheetリクエスト前に別途ログイン
# 　候補1で問題なく作動したため、実験していない

require "rails_helper"

RSpec.describe "Api::V1::Articles", type: :request do
  # index ( 修正済 )
  describe "GET /api/v1/articles" do
    # 候補1テスト中
    subject { get(api_v1_articles_path, headers: headers) }

    # テスト用の記事作成
    let!(:article1) { create(:article, updated_at: 2.days.ago) }
    let!(:article2) { create(:article, updated_at: 1.days.ago) }
    let!(:article3) { create(:article) }

    # ログインに必要な情報
    let(:user) { create(:user) }
    let(:headers) { user.create_new_auth_token }

    # インスタンスが正しく作成され、表示されているかをテスト
    it "記事一覧を取得できるて、レスポンスが正常" do
      subject
      # URLレポンスが正常？
      expect(response).to have_http_status(:ok)
    end

    it "インスタンスが3つ作成されているか" do
      subject
      res = JSON.parse(response.body)
      # インスタンスが3つ？
      expect(res.length).to eq 3
    end

    it "更新順に並び替えられているか" do
      subject
      res = JSON.parse(response.body)
      # 更新順序に並び替えられている？
      expect(res.map {|d| d["id"] }).to eq [article3.id, article2.id, article1.id]
    end

    it "keyを取得できているか" do
      subject
      res = JSON.parse(response.body)
      # 取得keyの確認
      expect(res[0].keys).to eq ["id", "title", "updated_at", "user"]
    end
  end

  # # openの一覧取得
  # describe "GET /api/v1/articles/open" do
  #   subject{ get(open_api_v1_articles_path, headers: headers) }
  #   # subject{ get(open_api_v1_articles_path) }

  #   # オブジェクト記事作成
  #   before { 3.times { create(:article) } }

  #   # ログイン認証用ユーザー作成
  #   # before { @user = create(:user) }

  #   # 認証情報の作成
  #   # let(:headers){ @user.create_new_auth_token }
  #   let(:user) { create(:user) }
  #   let(:headers) { user.create_new_auth_token }

  #   fit "レスポンスが正常" do
  #     binding.pry
  #     subject
  #     expect(response).to have_http_status :ok
  #   end

  #   it "オブジェクトが正常数作成されている" do
  #   end

  #   it "作成されたオブジェクトが降順に変更されている" do
  #   end
  # end

  # # draftの一覧取得
  # describe "GET /api/v1/articles/draft" do
  # end

  # show ( 修正済 )
  describe "GET /api/v1/articles/:id" do
    subject { get(api_v1_article_path(article_id), headers: headers) }

    # 認証情報の作成
    let(:headers) { user.create_new_auth_token }
    let(:user) { create(:user) }

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

    context "指定したidのユーザーが存在しない場合" do
      let(:article_id) { 10_000_000 }

      it "ユーザーが見つからない" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  # create ( 修正済 )
  describe "POST /api/v1/articles" do
    # リクエスト
    subject { post(api_v1_articles_path, params: params, headers: headers) }

    # 認証情報作成
    let(:headers) { user.create_new_auth_token }
    let(:user) { create(:user) }

    context "適切なパラメータを送信する" do
      # 記事作成に必要な情報
      let(:params) { { article: FactoryBot.attributes_for(:article) } }

      # 未実装な部分を補う
      # before { allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user) }

      it "記事が作成され、データベースに記事が保存される" do
        expect { subject }.to change { Article.count }.by(1)
      end

      it "記事が作成され、正常なbodyが登録される" do
        subject
        res = JSON.parse(response.body)
        expect(res["body"]).to eq params[:article][:body]
      end

      it "記事が作成され、正常なtitleが登録される" do
        subject
        res = JSON.parse(response.body)
        expect(res["title"]).to eq params[:article][:title]
      end

      it "記事が作成され、正常なstatusが登録される" do
        subject
        res = JSON.parse(response.body)
        expect(res["status"]).to eq params[:article][:status]
      end

      it "記事が作成され、正常なhttpレスポンスが返ってくる" do
        subject
        expect(response).to have_http_status(:ok)
      end
    end

    context "適切出ないパラメータを送信する" do
      # titleが指定されていない場合
      let(:params) do
        {
          article: {
            body: Faker::Quote.famous_last_words.to_s,
            # title: "#{n}_#{Faker::Job.title}"
            status: nil,
          },
        }
      end

      # 未実装部分を補完
      # let(:current_user) { create(:user) }
      # before { allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user) }

      it "エラーする" do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  # upadate ( 修正済 )
  describe "PATCH(PUT) /api/v1/articles/:id" do
    # リクエスト
    subject { patch(api_v1_article_path(article_id), params: params, headers: headers) }

    # 事前にユーザーとユーザーに紐づく記事を作成
    before do
      @user = create(:user)
      create(:article, user_id: @user.id)
    end

    # article_id作成
    let(:article_id) { article.id }
    let(:article) { @user.articles.first }

    # パラメータの作成
    let(:params) { { article: attributes_for(:article) } }

    # 認証情報作成
    let(:headers) { user.create_new_auth_token }
    let(:user) { @user }

    context "送信した値のみ更新" do
      it "レスポンスが正常" do
        subject
        expect(response).to have_http_status(:ok)
      end

      it "更新成功" do
        subject
        res = JSON.parse(response.body)
        expect(res["body"]).to eq params[:article][:body]
      end

      it "status情報が更新されている" do
        subject
        res = JSON.parse(response.body)
        expect(res["status"]).to eq params[:article][:status]
      end
    end

    context "送信していない値は未更新" do
      it "titleは変わらない" do
        subject
        res = JSON.parse(response.body)
        expect(res["title"]).to eq params[:article][:title]
      end
    end

    context "送信した値のうち、書き換えを許可していないものはそのまま" do
      it "idは変化なし" do
        subject
        res = JSON.parse(response.body)
        expect(res["id"]).to eq article.id
      end
    end
  end

  # destroy ( 修正済 )
  describe "DELETE /api/v1/articles/:id" do
    subject { delete(api_v1_article_path(article_id), headers: headers) }

    # 事前オブジェクト作成
    before do
      @user = create(:user)
      create(:article, user_id: @user.id)
    end

    # パラメータの設定
    let(:article_id) { article.id }
    let(:article) { @user.articles.first }

    # 認証情報の設定
    let(:headers) { user.create_new_auth_token }
    let(:user) { @user }

    it "正しい記事を取得し、記事が削除される" do
      subject
      expect(response.body).to eq ""
      # expect{ subject }.to change{ Article.count }.by(0)
    end
  end
end
