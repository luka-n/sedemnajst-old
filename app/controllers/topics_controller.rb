class TopicsController < ApplicationController
  include SortableTopics
  respond_to :html, :xml, :json

  def index
    min_date = Topic.minimum(:last_post_remote_created_at).to_date
    max_date = Date.today
    topics_q = params[:topics_q] || {}
    topics_q[:last_post_remote_created_on_gteq] ||= min_date.strftime("%d.%m.%Y")
    topics_q[:last_post_remote_created_on_lteq] ||= max_date.strftime("%d.%m.%Y")
    @topics_q = Topic.ransack(topics_q)
    @topics = @topics_q.result.
      includes(:user).
      order(map_sort_key(params[:sort], "last_post_remote_created_at_desc")).
      page(params[:page] || 1).per(40)
    @min = min_date.to_time(:utc).to_i * 1000
    @max = max_date.to_time(:utc).to_i * 1000
    respond_with @topics
  end

  def show
    @topic = Topic.find(params[:id])
    @posts = @topic.posts.includes(:user).order(:remote_created_at).
      page(params[:page] || 1).per(40)
    @title = @topic.to_s
    respond_with @topic
  end
end
