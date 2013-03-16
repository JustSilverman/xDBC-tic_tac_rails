class SessionsController < ApplicationController

  def login
    @user = User.find_by_email(params[:email])
    if @user && @user.authenticate(params[:password])
      login(@user.id)
    end
    render 'games/index'
  end

  def logout
    logout
    redirect_to root_path
  end
end
