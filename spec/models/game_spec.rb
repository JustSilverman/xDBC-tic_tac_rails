require 'spec_helper'

describe Game do
  let!(:game) { create(:game) }

  context 'validations' do
    it { should validate_presence_of(:board) }
    it { should validate_presence_of(:player1) }
    it { should validate_uniqueness_of(:player1_id).scoped_to(:player2_id) }
  end

  context 'associations' do
    it { should belong_to(:player1) }
    it { should belong_to(:player2) }
    it { should belong_to(:winner) }
  end  

  context '.new' do
    it 'will have a board that is a string' do
      Game.new.board.should be_a(String)
    end

    it 'will have a blank board' do
      Game.new.board.should eq "-" * 9
    end
  end

  context '#update!' do
    let(:game) { create(:game, :board => "-" * 9) }
    let(:invalid_board) { "X" * 3 }
    let(:valid_board) { Array.new(9) { ["O", "X", "-"].sample}.join("") }
    
    it "does not update board unless argument is a String" do
      expect {
        game.update!((0..8).to_a)
      }.to_not change(game, :board)
    end  

    it "does not update board unless argument has 9 characters" do
      expect {
        game.update!(invalid_board)
      }.to_not change(game, :board)
    end  

    it "updates the game's board" do
      expect {
        game.update!(valid_board)
      }.to change { game.board }.to(valid_board) 
    end  
  end

  context '#player_token' do 
    let(:game) { create(:game) }
    let(:invalid_id) { game.player1_id + game.player2_id }

    it "returns nil for invalid player id" do
      game.player_token(invalid_id).should eq nil
    end  

    it "player_token should be O if user_id equals player1_id in game" do
      game.player_token(game.player1_id).should eq 'O'
    end  

    it "player_token should be X if user_id equals player2_id in game" do
      game.player_token(game.player2_id).should eq 'X'
    end  
  end

  context 'player?' do
    let(:player1) { create(:user) }
    let(:game)    { create(:game, :player1 => player1) }
    let(:player3) { create(:user) }

    it 'user is valid player' do
      game.player?(player1.id).should eq true
    end 

    it 'user is not valid player' do
      game.player?(player3.id).should eq false
    end 
  end 

  context 'set_winner!' do
    let(:player1)  { create(:user) }
    let(:game)     { create(:game, :player1 => player1) }
    let(:game_won) { create(:game_with_winner) }
  
    it 'winner must be one of the valid players' do
      expect {
        game.set_winner!(player1.id)
      }.to change {game.winner_id}.to(player1.id)
    end

    it 'return false if winner has already been set' do
      game_won.set_winner!(player1).should eq false
    end  
  end
end
