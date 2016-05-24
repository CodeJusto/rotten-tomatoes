class Admin::UsersController < ApplicationController
  def index
    @users = User.order(:firstname).page(params[:page])
  end


  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to movies_path, notice: "Welcome aboard, #{@user.firstname}!"
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end
end
