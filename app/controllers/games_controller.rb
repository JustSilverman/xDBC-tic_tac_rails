class GamesController < ApplicationController
  respond_to :js, :json, :html

  def index
    @user = User.new
    @games = Game.all
  end

  def create
    @game = Game.new(player1: current_user)
    redirect_to game_path(@game)
  end

  def update
    @game = Game.find(params[:id])
    @game.update_attributes(:player2 => current_user)
    redirect_to game_path(@game)
  end

  def show
    @game = Game.find(params[:id])
  end
   
  def winner
  end

  def moves
    @game = Game.find

    @game.update!(params[:player_id])

    respond_with @game
  end

end
