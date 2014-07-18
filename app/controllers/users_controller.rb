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
    options[:between] = if (q = params[:user_posts_by_dow_q])
                          Date.parse(q[:day_gteq])..Date.parse(q[:day_lteq])
                        else
                          (Date.today - 3.months)..Date.today
                        end
    render json: Oj.
      dump("data" => UserPostsByDow.series_for(user, options),
           "min" => UserPostsByDow.minimum(:day).to_time(:utc).to_i * 1000,
           "max" => Date.today.to_time(:utc).to_i * 1000,
           "from" => options[:between].min.to_time(:utc).to_i * 1000,
           "to" => options[:between].max.to_time(:utc).to_i * 1000)
  end

  def pphod
    user = User.find(params[:id])
    options = {}
    options[:between] = if (q = params[:user_posts_by_hod_q])
                          Date.parse(q[:day_gteq])..Date.parse(q[:day_lteq])
                        else
                          (Date.today - 3.months)..Date.today
                        end
    render json: Oj.
      dump("data" => UserPostsByHod.series_for(user, options),
           "min" => UserPostsByHod.minimum(:day).to_time(:utc).to_i * 1000,
           "max" => Date.today.to_time(:utc).to_i * 1000,
           "from" => options[:between].min.to_time(:utc).to_i * 1000,
           "to" => options[:between].max.to_time(:utc).to_i * 1000)
  end
end
