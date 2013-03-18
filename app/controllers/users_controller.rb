class UsersController < ApplicationController

  def create
    puts params
    @user = User.new(params[:user])
    if @user.save
      login!(@user.id)
      redirect_to root_path
    else
      render 'games/index'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy if @user
  end

  def show
  end
end
