module Api
  module V1
    class ArticlesController < Api::V1::BaseApiController
      respond_to :json
      before_action :set_article, only: [:show, :update, :destroy]
      # Userがサインインしていなければ401エラーを返す
      before_action :authenticate_api_v1_user!
      # ↑追加したらテストでエラーが出る様になった

      def index
        @articles = Article.order(updated_at: :desc)
        render json: @articles, each_serializer: Api::V1::ArticlePreviewSerializer
      end

      def show
        render json: @article
      end

      def create
        article = current_api_v1_user.articles.create!(article_params)
        render json: article
      end

      def update
        article = current_api_v1_user.articles.find(params[:id])
        article.update!(article_params)
        # 記事更新時に article.id が nil なのが問題
        render json: article
      end

      def destroy
        article = current_api_v1_user.articles.find(params[:id])
        article.destroy!
      end

      private

        def article_params
          params.require(:article).permit(:title, :body)
        end

        def set_article
          @article = Article.find(params[:id])
        end
    end
  end
end
