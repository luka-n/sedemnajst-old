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
    from = q_to_date_time(params[:q] || "last_month")
    to = DateTime.now.end_of_day
    data = UserPostsByDow.series_for(user, between: from..to)
    render json: Oj.dump(data)
  end

  def pphod
    user = User.find(params[:id])
    from = q_to_date_time(params[:q] || "last_month")
    to = DateTime.now.end_of_day
    data = UserPostsByHod.series_for(user, between: from..to)
    render json: Oj.dump(data)
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
