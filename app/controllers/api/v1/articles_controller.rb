module Api
  module V1
    class ArticlesController < Api::V1::BaseApiController
      respond_to :json
      before_action :set_article, only: [:show, :update, :destroy]

      def index
        @articles = Article.order(updated_at: :desc)
        render json: @articles, each_serializer: Api::V1::ArticlePreviewSerializer
      end

      def show
        render json: @article
      end

      def create
        article = current_user.articles.create!(article_params)
        render json: article
      end

      def update
        article = current_user.articles.update!(article_params)
        render json: article
      end

      def destroy
        @article.destroy
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
