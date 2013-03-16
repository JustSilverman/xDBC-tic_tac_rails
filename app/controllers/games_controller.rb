class GamesController < ApplicationController
  before_filter :authorized?, :only => [:show, :moves]
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
    @game = Game.find(params[:id])
    @game.set_winner!(params[:winner_id])
    redirect_to root_path
  end

  def moves
    @game = Game.find
    @game.update!(params[:player_id])

    respond_with @game
  end

  private 

  def authorized?
    @game = Game.find(params[:id])
    redirect_to root_path unless @game.player?(current_user)
  end



end
