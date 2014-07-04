class Users::PostsController < ApplicationController
  respond_to :xml, :json

  def index
    @posts = Post.page(params[:page] || 1).per(40)
    respond_with @posts
  end
end
