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

      def create
        article = Article.new(article_params)
        article.save!

        render :show
      end

      def update
      end

      def destroy
      end

      private

        def article_params
          params.request(:article).permit(:title, :body)
        end
    end
  end
end
