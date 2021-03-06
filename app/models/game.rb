class Game < ActiveRecord::Base

  attr_accessible :board, :player1, :player2, :winner, :player1_id, :player2_id
  
  validates :player1, :presence => true
  validate :unique_players

  belongs_to :player1, :class_name => 'User'
  belongs_to :player2, :class_name => 'User'
  belongs_to :winner, :class_name => 'User'

  before_create { self.board = " " * 9 }

  def update!(new_board)
    if new_board.class == String && new_board.length == 9
      self.update_attributes(:board => new_board)
    end
  end

  def player_token(user_id)
    return nil unless player?(user_id)
    self.player1_id == user_id ? "X" : "O"
  end

  def player?(user_id)
    players.include?(user_id)
  end  

  def set_winner!(user_id)
    return false unless self.player?(user_id)
    self.update_attributes(:winner => User.find(user_id))
  end  

  def complete?
    !self.board.include?(" ") || self.winner
  end  

  def self.incomplete
    Game.all.delete_if { |game| game.complete? }
  end

  private
  def players
    [self.player1_id, self.player2_id]
  end

  def unique_players
    if self.player1_id == self.player2_id  
      errors[:base] << "Players must be unique"
    end  
  end  
end
