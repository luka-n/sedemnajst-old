class TopicsController < ApplicationController
  respond_to :html, :xml, :json

  def index
    @topics_q = Topic.ransack(params[:topics_q])
    @topics_q.last_post_remote_created_at_gteq ||=
      Topic.order(:last_post_remote_created_at).
      first.last_post_remote_created_at
    @topics_q.last_post_remote_created_at_lteq ||=
      Topic.order(:last_post_remote_created_at).
      last.last_post_remote_created_at
    @topics_q.last_post_remote_created_at_lteq =
      @topics_q.last_post_remote_created_at_lteq.end_of_day
    @topics = @topics_q.result.order(last_post_remote_created_at: :desc).
      page(params[:page] || 1).per(40)
    respond_with @topics
  end

  def show
    @topic = Topic.find(params[:id])
    @posts = @topic.posts.order(:remote_created_at).
      page(params[:page] || 1).per(40)
    @title = @topic.to_s
    respond_with @topic
  end
end
