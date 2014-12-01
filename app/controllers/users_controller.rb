class UsersController < ApplicationController

  before_action :require_signin, except: [:new, :create]
  before_action :find_user, only: [:show, :edit, :update, :destroy]
  before_action :require_current_user, except: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_url, notice: "Thank you for signing up!"
    else
      render "new"
    end
  end

  # def create
  # @user = User.new(user_params)
  # if @user.save
  #   sign_in @user
  #   redirect_to @user, notice: "Thank you for signing up!"
  # else
  #   render "new"
  # end

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user
    else
      render "edit"
    end
  end

  def destroy
    @user.destroy
    redirect_to root_path
  end

  private
  def find_user
    @user = User.find(params[:id])
  end
  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  def require_current_user
    if !current_user?(@user)
      redirect_to root_path
    end
  end
end
