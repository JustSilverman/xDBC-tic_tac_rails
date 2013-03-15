require 'spec_helper'

describe Game do
  let!(:game) { create(:game) }

  context 'validations' do
    it { should validate_presence_of(:board) }
    it { should validate_presence_of(:player1) }
    it { should validate_presence_of(:active_player) }
    it { should validate_uniqueness_of(:player1).scoped_to(:player2) }
  end

  context 'associations' do
    it { should belong_to(:player1) }
    it { should belong_to(:player2) }
    it { should have_one(:active_player) }
    it { should have_one(:winner) }
  end  
  
end
