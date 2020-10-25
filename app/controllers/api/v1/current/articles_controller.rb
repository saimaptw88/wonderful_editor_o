class Api::V1::Current::ArticlesController < Api::V1::BaseApiController
  # Userがサインインしていなければ401エラーを返す
  before_action :authenticate_api_v1_user!

  def index
    articles = current_api_v1_user.articles.open.order(updated_at: :desc)
    render json: articles
  end
end
