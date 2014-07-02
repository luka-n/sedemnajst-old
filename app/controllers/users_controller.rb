# -*- coding: utf-8 -*-
class UsersController < ApplicationController
  def index
    @users_q = User.ransack(params[:users_q])
    @users = @users_q.result.order(:name).page(params[:page] || 1).per(40)
  end

  def show
   @user = User.find(params[:id])

   @ppdow_q = params[:ppdow_q].try(:to_sym) || :all_time
   @pphod_q = params[:pphod_q].try(:to_sym) || :all_time
   
   @ppdow_gt = q_to_date(@ppdow_q)
   @pphod_gt = q_to_date(@pphod_q)

   @ppdow_posts = if @ppdow_gt then @user.posts.
                      where(Post.arel_table[:remote_created_at].gt(@ppdow_gt))
                  else @user.posts end
   @pphod_posts = if @pphod_gt then @user.posts.
                      where(Post.arel_table[:remote_created_at].gt(@pphod_gt))
                  else @user.posts end

   @posts_per_dow = @ppdow_posts.group_by_day_of_week(:remote_created_at).count.
     map { |k,v| [dow_to_name(k), v] }
   @posts_per_hod = @pphod_posts.group_by_hour_of_day(:remote_created_at).count
  end

  private

  def q_to_date(q)
    case q when :all_time then nil
    when :last_year then Date.today - 1.year
    when :last_month then Date.today - 1.month
    when :last_week then Date.today - 1.week end
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
