# -*- coding: utf-8 -*-
class PasswordsController < ApplicationController
  layout "noauth"
  skip_before_filter :authenticate_user!

  def new
    @title = "geslo prosim"
  end

  def create
    @user = User.find_by_case_insensitive_name(params[:name])
    start_over and return unless @user
    @user.send_password_request
    flash[:notice] = "poslali smo ti nadaljne inštrukcije"
    redirect_to new_session_path
  end

  def edit
    @token = params[:token]
    @user = User.find_by_password_request_token(@token)
    start_over and return unless @user
    @title = "novo geslo"
  end

  def update
    @token = params[:user][:password_request_token]
    @user = User.find_by_password_request_token(@token)
    start_over and return unless @user
    @user.password_required = true
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.valid?
      @user.password_request_token = nil
      @user.password_requested_at = nil
      @user.save
      flash[:notice] = "sedaj se lahko prijaviš"
      redirect_to new_session_path
    else
      render :edit
    end
  end

  private

  def start_over
    flash[:alert] = "nak, gremo od začetka"
    redirect_to new_password_path
  end
end
