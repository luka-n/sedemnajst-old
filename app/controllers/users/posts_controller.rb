class Users::PostsController < ApplicationController
  include SortablePosts
  respond_to :html, :xml, :json

  def index
    @user = User.find(params[:user_id])
    @posts = @user.posts.ransack(params[:posts_q]).result.
      order(map_sort_key(params[:sort], :remote_created_at)).
      page(params[:page] || 1).per(40)
    @title = "posti od #@user"
    respond_with @posts
  end
end
