class Api::V1::Articles::DraftController < ApplicationController
  # Userがサインインしていなければ401エラーを返す
  before_action :authenticate_api_v1_user!

  def index
    articles = current_api_v1_user.articles.draft.order(updated_at: :desc)
    render json: articles
  end

  def show
    article = current_api_v1_user.articles.draft.find(params[:id])
    render json: article
  end

  private

    def article_params
      params.require(:article).permit(:title, :body, :status)
    end
end