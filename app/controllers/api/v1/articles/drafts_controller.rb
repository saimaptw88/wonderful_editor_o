class Api::V1::Articles::DraftsController < ApplicationController
  # Userがサインインしていなければ401エラーを返す
  before_action :authenticate_api_v1_user!

  def index
    articles = current_api_v1_user.articles.draft.order(updated_at: :desc)
    render json: articles, each_serializer: Api::V1::Articles::DraftSerializer
  end

  def show
    article = current_api_v1_user.articles.draft.find(params[:id])
    render json: article, serializer: Api::V1::Articles::DraftSerializer
  end

  private

    def article_params
      params.require(:article).permit(:title, :body, :status)
    end
end
