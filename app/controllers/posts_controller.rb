class PostsController < ApplicationController
  include SortablePosts
  respond_to :xml, :json

  def index
    @posts = Post.
      order(map_sort_key(params[:sort], :remote_created_at)).
      page(params[:page] || 1).per(40)
    respond_with @posts
  end

  def goto
    post = Post.includes(:topic).find(params[:id])
    post_idx = post.topic.posts.
      where("remote_created_at < ?", post.remote_created_at).
      count
    page = ((post_idx + 1) / 40.0).ceil
    redirect_to topic_path(post.topic, page: page, anchor: "p#{post.id}")
  end
end
