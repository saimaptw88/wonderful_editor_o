class Api::V1::BaseApiController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken
  # def current_user
  #   # 左辺が存在しない場合、右辺の値が代入される
  #   @current_user ||= User.first
  # end
end
