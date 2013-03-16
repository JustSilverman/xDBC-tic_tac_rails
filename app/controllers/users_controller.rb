class UsersController < ApplicationController

  def create
    @user = User.new(params[:user])
  end

  def update
  end

  def show
  end

  def destroy
  end

  def login
  end

  def logout
  end

end
