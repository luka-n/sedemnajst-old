class Users::PostsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @posts = @user.posts.page(params[:page] || 1).per(40)
    @title = @user.to_s
  end
end
