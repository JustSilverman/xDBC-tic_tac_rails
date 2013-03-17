require 'spec_helper'

describe User do
  context 'validations' do
    let!(:user) { create(:user) }

    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
    it { should_not allow_value("blah").for(:email) }
    it { should allow_value("a@b.com").for(:email) }
    it { should validate_confirmation_of(:password) }
    it { should validate_uniqueness_of(:username) }
    it { should validate_uniqueness_of(:email) }
  end

  context 'associations' do
    it { should have_many(:player1_games) }
    it { should have_many(:player2_games) }
    it { should have_many(:won_games) }
  end

  context '#authenticate' do
    let(:user) { create(:user) }

    it 'logs in with the correct password' do
      expect {
        user.authenticate("password")
      }.to be_true
    end

    it 'can not log in with the incorrect password' do
      expect {
        user.authenticate("notpassword")
      }.to be_true
    end
  end

  context '#games' do
    let(:user)   { create(:user) }
    let(:game_1) { create(:game, :player1 => user) }
    let(:game_2) { create(:game, :player2 => user) }

    it 'returns an activerecord relation' do
      user.games.should be_an(ActiveRecord::Relation)
    end

    it 'returns an empty activerecord relation if user has no games' do
      user.games.empty?.should be_true
    end

    it 'does not return nil if user has no games' do
      user.games.nil?.should_not be_true
    end

    it 'includes games where user is player1 or player2' do
      user.games.should include(game_1, game_2)
    end
  end
end
