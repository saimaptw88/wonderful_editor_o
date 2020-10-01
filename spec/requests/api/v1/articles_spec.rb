require 'rails_helper'

RSpec.describe "Api::V1::Articles", type: :request do
  describe "GET /api/v1/articles" do
    subject { get(api_v1_articles_path) }

    # before do
    #   user = FactoryBot.create(:user)
    #   # インスタンスを作成
    #   3.times { FactoryBot.create(:article, user_id: user.id, updated_at: 1.days.ago) }
    #   FactoryBot.create(:article, user_id: user.id)
    #   FactoryBot.create(:article, user_id: user.id, updated_at: 1.days.ago)
    #   FactoryBot.create(:article, user_id: user.id, updated_at: 2.days.ago)
    # end


    let!(:article1) { create(:article, updated_at: 2.days.ago) }
    let!(:article2) { create(:article, updated_at: 1.days.ago) }
    let!(:article3) { create(:article) }

    # インスタンスが正しく作成され、表示されているかをテスト
    fit "記事一覧を取得できる" do
      subject
      res = JSON.parse( response.body )
      # URLレポンスが正常？
      expect(response).to have_http_status(200)
      # インスタンスが3つ？
      expect( res.length ).to eq 3
      # 更新順序に並び替えられている？
      expect(res.map{|d| d["id"]}).to eq [article3.id, article2.id, article1.id]
      # 取得keyの確認
      expect( res[0].keys ).to eq ["id", "title", "updated_at", "user"]
    end
  end

  # describe "POST /api/v1/articles" do
  # end

  # describe "PATCH(PUT) /api/v1/articles/:id" do
  # end

  # describe "DELETE /api/v1/articles/:id" do
  # end
end
