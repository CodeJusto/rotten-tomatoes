class Admin::UsersController < ApplicationController
  def index
    @users = User.order(:firstname).page(params[:page])
  end
end
