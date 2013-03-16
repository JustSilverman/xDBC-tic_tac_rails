class Game < ActiveRecord::Base

  attr_accessible :board, :player1, :player2, :winner
  
  validates :player1, :presence => true

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
    debugger
    return false unless self.player?(user_id)
    self.update_attributes(:winner => User.find(user_id))
  end    

  private
  def players
    [self.player1_id, self.player2_id]
  end
end
