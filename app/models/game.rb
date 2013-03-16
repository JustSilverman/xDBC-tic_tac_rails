class Game < ActiveRecord::Base

  attr_accessible :active_player, :board, :player1, :player2, :winner
  
  validates :board, :presence => true
  validates :player1, :presence => true
  validates :player1_id, :uniqueness => { :scope => :player2_id }
  validates :active_player, :presence => true

  belongs_to :player1, :class_name => 'User'
  belongs_to :player2, :class_name => 'User'
  belongs_to :active_player, :class_name => 'User'
  belongs_to :winner, :class_name => 'User'

  after_initialize { self.board = "-" * 9 }

  def update!(new_board)
    if new_board.class == String && new_board.length == 9
      self.update_attributes(:board => new_board)
    end
  end

  def player_token(user_id)
    return nil unless [player1_id, player2_id].include? user_id
    self.player1_id == user_id ? "O" : "X"
  end
end
