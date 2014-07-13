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
    else
      options[:between] = (DateTime.now - 3.months)..DateTime.now
    end
    data = UserPostsByDow.series_for(user, options)
    min = UserPostsByDow.minimum(:day).to_i
    max = UserPostsByDow.maximum(:day).to_i
    render json: Oj.dump(data: data, min: min, max: max,
                         from: options[:between].min.to_i,
                         to: options[:between].max.to_i)
  end

  def pphod
    user = User.find(params[:id])
    options = {}
    if (q = params[:user_posts_by_hod_q])
      from = DateTime.parse(q[:day_gt])
      to = DateTime.parse(q[:day_lt])
      options[:between] = from..to
    else
      options[:between] = (DateTime.now - 3.months)..DateTime.now
    end
    data = UserPostsByHod.series_for(user, options)
    min = UserPostsByHod.minimum(:hour).to_i
    max = UserPostsByHod.maximum(:hour).to_i
    render json: Oj.dump(data: data, min: min, max: max,
                         from: options[:between].min.to_i,
                         to: options[:between].max.to_i)
  end
end
