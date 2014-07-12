# -*- coding: utf-8 -*-
class UsersController < ApplicationController
  include SortableUsers
  respond_to :html, :xml, :json

  def index
    @users_q = User.ransack(params[:users_q])
    @users = @users_q.result.
      order(map_sort_key(params[:sort], "name")).
      page(params[:page] || 1).per(40)
    @title = "uporabniki"
    respond_with @users
  end

  def show
    @user = User.find(params[:id])
    @title = @user.to_s
    respond_with @user
  end

  def pph
    user = User.find(params[:id])
    data = UserPostsByHour.series_for(user)
    render json: Oj.dump(data)
  end

  def ppdow
    user = User.find(params[:id])
    options = {}
    if (q = params[:user_posts_by_dow_q])
      from = DateTime.parse(q[:day_gt])
      to = DateTime.parse(q[:day_lt])
      options[:between] = from..to
    end
    data = UserPostsByDow.series_for(user, options)
    min = user.posts.minimum(:remote_created_at).to_i
    max = user.posts.maximum(:remote_created_at).to_i
    render json: Oj.dump(data: data, min: min, max: max)
  end

  def pphod
    user = User.find(params[:id])
    options = {}
    if (q = params[:user_posts_by_hod_q])
      from = DateTime.parse(q[:day_gt])
      to = DateTime.parse(q[:day_lt])
      options[:between] = from..to
    end
    data = UserPostsByHod.series_for(user, options)
    min = user.posts.minimum(:remote_created_at).to_i
    max = user.posts.maximum(:remote_created_at).to_i
    render json: Oj.dump(data: data, min: min, max: max)
  end

  private

  def q_to_date_time(q)
    case q
    when "all_time" then DateTime.new(1970)
    when "last_year" then DateTime.now.beginning_of_day - 1.year
    when "last_month" then DateTime.now.beginning_of_day - 1.month
    when "last_week" then DateTime.now.beginning_of_day - 1.week
    end
  end
end
