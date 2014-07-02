class Users::TopicsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @topics = @user.topics.page(params[:page] || 1).per(40)
    @title = @user.to_s
  end
end
