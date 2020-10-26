class Api::V1::Current::ArticlesSerializer < ActiveModel::Serializer
  attributes :id, :title, :status, :updated_at
  belongs_to :user, serializer: Api::V1::UserSerializer
end
