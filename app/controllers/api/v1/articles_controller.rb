module Api
  module V1
    class ArticlesController < Api::V1::BaseApiController
      respond_to :json
      def index
        @articles = Article.order(updated_at: :desc)
        render json: @articles, each_serializer: Api::V1::ArticlePreviewSerializer
      end

      def show
        @article = Article.find(params[:id])
        # render json: @article
      end
    end
  end
end
