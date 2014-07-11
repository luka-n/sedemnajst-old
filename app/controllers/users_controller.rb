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
    data = user.posts.group_by_hour(:remote_created_at).count.map do |k,v|
      [k.to_i * 1000, v]
    end
    render json: data
  end

  def ppdow
    user = User.find(params[:id])
    from = q_to_date_time(params[:q] || "last_month")
    to = DateTime.now.end_of_day
    posts = user.posts.where("remote_created_at BETWEEN ? AND ?", from, to)
    data = posts.group_by_day_of_week(:remote_created_at).count.
      map { |k,v| [dow_to_name(k), v] }
    render json: data
  end

  def pphod
    user = User.find(params[:id])
    from = q_to_date_time(params[:q] || "last_month")
    to = DateTime.now.end_of_day
    posts = user.posts.where("remote_created_at BETWEEN ? AND ?", from, to)
    data = posts.group_by_hour_of_day(:remote_created_at).count.to_a
    render json: data
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

  def dow_to_name(dow)
    case dow
    when 0 then "pon"
    when 1 then "tor"
    when 2 then "sre"
    when 3 then "čet"
    when 4 then "pet"
    when 5 then "sob"
    when 6 then "ned"
    end
  end
end
