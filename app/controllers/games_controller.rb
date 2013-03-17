class GamesController < ApplicationController
  # before_filter :authorized?, :only => [:show, :moves]
  respond_to :js, :json, :html

  def index
    @user = User.new
    @games = Game.all
  end

  def create
    @game = Game.create(player1: current_user)
    redirect_to game_path(@game.id)
  end

  def update
    @game = Game.find(params[:id])
    @game.update_attributes(:player2 => current_user)
    redirect_to game_path(@game.id)
  end

  def show
    @game = Game.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render :json => @game.board.to_json }
    end
  end
   
  def winner
    @game = Game.find(params[:game_id])
    @game.set_winner!(params[:winner_id].to_i)
    redirect_to root_path
  end

  def moves
    @game = Game.find(params[:game_id])
    @game.update!(params[:board])

    render :json => @game.board.to_json
  end

  private 

  def authorized?
    @game = Game.find(params[:id])
    redirect_to root_path unless @game.player?(current_user)
  end
end
