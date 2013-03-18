class SessionsController < ApplicationController

  def login
    puts params
    @user = User.find_by_email(params[:user][:email])
    if @user && @user.authenticate(params[:user][:password])
      login!(@user.id)
    end
    @user = User.new unless @user
    redirect_to root_path
  end

  def logout
    logout!
    redirect_to root_path
  end
end
