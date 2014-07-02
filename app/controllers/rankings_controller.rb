class RankingsController < ApplicationController
  def index
    @users_by_posts = User.order(posts_count: :desc).limit(10)
    @users_by_topics = User.order(topics_count: :desc).limit(10)
    @title = "kralji gnoja"
  end
end
