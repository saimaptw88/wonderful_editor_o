class HomeController < ApplicationController
  def index
    @message = "test"
    render json: @message
  end
end
