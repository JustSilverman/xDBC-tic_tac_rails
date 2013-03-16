class SessionsController < ApplicationController

  def login
    @user = User.find_by_email(params[:email])
    if @user && @user.authenticate(params[:password])
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
