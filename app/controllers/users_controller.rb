# -*- coding: utf-8 -*-
class UsersController < ApplicationController
  include SortableUsers
  respond_to :html, :xml, :json

  def index
    @users_q = User.ransack(params[:users_q])
    @users = @users_q.result.
      order(map_sort_key(params[:sort], :name)).
      page(params[:page] || 1).per(40)
    @title = "uporabniki"
    respond_with @users
  end

  def show
    @user = User.find(params[:id])
    @ppd_q = params[:ppd_q] || "last_week"
    @ppdow_q = params[:ppdow_q] || "last_week"
    @pphod_q = params[:pphod_q] || "last_week"
    @title = @user.to_s
    respond_with @user
  end

  def ppd
    user = User.find(params[:id])
    ppd_gt = q_to_date(params[:q] || "last_week")
    ppd_posts = if ppd_gt
                  user.posts.where("remote_created_at > ?", ppd_gt)
                else
                  user.posts
                end
    posts_per_day = ppd_posts.group_by_day(:remote_created_at).count
    render json: posts_per_day
  end

  def ppdow
    user = User.find(params[:id])
    ppdow_gt = q_to_date(params[:q] || "last_week")
    ppdow_posts = if ppdow_gt
                    user.posts.where("remote_created_at > ?", ppdow_gt)
                  else
                    user.posts
                  end
    posts_per_dow = ppdow_posts.group_by_day_of_week(:remote_created_at).count.
      map { |k,v| [dow_to_name(k), v] }
    render json: posts_per_dow
  end

  def pphod
    user = User.find(params[:id])
    pphod_gt = q_to_date(params[:q] || "last_week")
    pphod_posts = if pphod_gt
                    user.posts.where("remote_created_at > ?", pphod_gt)
                  else
                    user.posts
                  end
    posts_per_hod = pphod_posts.group_by_hour_of_day(:remote_created_at).count
    render json: posts_per_hod
  end

  private

  def q_to_date(q)
    case q when "all_time" then nil
    when "last_year" then Date.today - 1.year
    when "last_month" then Date.today - 1.month
    when "last_week" then Date.today - 1.week end
  end

  def dow_to_name(dow)
    case dow
    when 0 then "Pon"
    when 1 then "Tor"
    when 2 then "Sre"
    when 3 then "Čet"
    when 4 then "Pet"
    when 5 then "Sob"
    when 6 then "Ned" end
  end
end
