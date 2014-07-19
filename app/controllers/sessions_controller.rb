# -*- coding: utf-8 -*-
class SessionsController < ApplicationController
  layout "noauth"
  skip_before_filter :authenticate_user!

  def new
    @user = User.new
    @title = "prijava"
  end

  def create
    @user = User.find_by_name(params[:user_session][:name])
    if @user && @user.authenticate(params[:user_session][:password])
      session[:user_id] = @user.id
      redirect_to root_path
    else
      flash[:alert] = "ne bo štimalo"
      redirect_to new_session_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to new_session_path
  end
end
