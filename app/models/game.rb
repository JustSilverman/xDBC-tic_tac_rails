class Game < ActiveRecord::Base
  attr_accessible :active_player, :board, :player1, :player2, :winner
  belongs_to :player1, :class_name => 'User'
  belongs_to :player2, :class_name => 'User'
  belongs_to :active_player, :class_name => 'User'
  belongs_to :winner, :class_name => 'User'

  validates :board, :presence => true
  validates :player1, :presence => true
  validates :active_player, :presence => true

end
