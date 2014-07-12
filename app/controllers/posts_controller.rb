class PostsController < ApplicationController
  include SortablePosts
  respond_to :html, :xml, :json

  def index
    @posts = Post.ransack(params[:posts_q]).result.
      order(map_sort_key(params[:sort], "remote_created_at_desc")).
      page(params[:page] || 1).per(40)
    @title = "posti"
    respond_with @posts
  end

  def show
    post = Post.includes(:topic).find(params[:id])
    post_idx = post.topic.posts.
      where("remote_created_at < ?", post.remote_created_at).
      count
    page = ((post_idx + 1) / 40.0).ceil
    redirect_to topic_path(post.topic, page: page, anchor: "post-#{post.id}")
  end
end
