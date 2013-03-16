class GamesController < ApplicationController

  def index
    @user = User.new
    @game = Game.new
  end

  def create
    @game = Game.new(params[:game])
  end

  def update
  end

  def show
  end
   
  def moves    
  end

  def winner
  end

  def status
  end

end
