class Api::V1::ArticlePreviewSerializer < ActiveModel::Serializer
  attributes :id, :title, :status, :updated_at, :body
  belongs_to :user, serializer: Api::V1::UserSerializer
end
