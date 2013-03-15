require 'spec_helper'

describe Game do
  let!(:game) { create(:game) }

  context 'validations' do
    it { should validate_presence_of(:board) }
    it { should validate_presence_of(:player1) }
    it { should validate_presence_of(:active_player) }
    it { should validate_uniqueness_of(:player1_id).scoped_to(:player2_id) }
  end

  context 'associations' do
    it { should belong_to(:player1) }
    it { should belong_to(:player2) }
    it { should belong_to(:active_player) }
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
end
