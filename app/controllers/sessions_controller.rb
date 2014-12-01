class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    redirect_to root_url
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end
end
# def create
#   user = User.find_by_email(params[:session][:email].downscase)
#   #authenticate is a method that has_secure_password provides us with
#   if user && user.authenticate(params[:session][:password])
#     sign_in user
#     redirect_back_or root_url, notice: "Logged in!"
#   else
#     flash.now.alert = "Email or password is invalid"
#     render "new"
#   end


