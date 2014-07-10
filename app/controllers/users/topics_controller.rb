class Users::TopicsController < ApplicationController
  include SortableTopics
  respond_to :html, :xml, :json

  def index
    @user = User.find(params[:user_id])
    @topics = @user.topics.
      order(map_sort_key(params[:sort], "last_post_remote_created_at_desc")).
      page(params[:page] || 1).per(40)
    @title = "teme od #@user"
    respond_with @topics
  end
end
