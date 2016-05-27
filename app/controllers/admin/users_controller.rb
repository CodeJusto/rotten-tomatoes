class Admin::UsersController < ApplicationController
  
  before_filter :require_admin

  def index
    @users = User.order(:firstname).page(params[:page])
  end

  def new
    @user = User.new
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

  def show
   @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(user_params)
      redirect_to admin_users_path
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    unless @user == current_user
      UserMailer.delete_email(@user).deliver_later
      @user.destroy
      redirect_to admin_users_path, notice: "User was successfully wiped out."
    else
      redirect_to admin_users_path, notice: "You cannot delete yourself!"
    end
  end

  def impersonate
    @user = User.find(params[:user_id])
    session[:original_admin_id] ||= current_user.id
    session[:user_id] = @user.id
    redirect_to :root, notice: "Now logged in as #{@user.full_name}"
  end

  def switch_back
    session[:user_id] = session[:original_admin_id]
    session[:original_admin_id] = nil
    redirect_to :root
  end

  protected

  def user_params
    params.require(:user).permit(:email, :firstname, :lastname, :password, :password_confirmation, :admin)
  end

  private

  def require_admin
    redirect_to :root, alert: "NOPE" unless admin?
  end

  def admin?
    current_user && (current_user.admin? || impersonating?)
  end

  def impersonating?
    if session[:original_admin_id]
      !!admin_user
    else
      false
    end
  end

  def admin_user
    if current_user.admin?
      current_user
    elsif session[:original_admin_id]
      User.where(admin: true).find(session[:original_admin_id])

    end
  end


  helper_method :admin?, :impersonating?, :admin_user
end
