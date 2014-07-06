class PostsController < ApplicationController
  include SortablePosts
  respond_to :xml, :json

  def index
    @posts = Post.
      order(map_sort_key(params[:sort], :remote_created_at)).
      page(params[:page] || 1).per(40)
    respond_with @posts
  end
end
