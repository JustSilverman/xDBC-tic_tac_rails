class SessionsController < ApplicationController

  def login
    @user = User.find_by_email(params[:user][:email])
    if @user && @user.authenticate(params[:user][:password])
      login!(@user.id)
      redirect_to root_path and return
    end
    @user = User.new unless @user
    @message = "Invalid credentials"

    render 'games/index'
  end

  def logout
    logout!
    redirect_to root_path
  end
end
