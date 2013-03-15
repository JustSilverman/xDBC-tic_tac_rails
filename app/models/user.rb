class User < ActiveRecord::Base
  EMAIL_REGEX = /.+@.+\..+/

  has_many :player1_games, :class_name => 'Game', :foreign_key => 'player1_id'
  has_many :player2_games, :class_name => 'Game', :foreign_key => 'player2_id'
  has_many :won_games,     :class_name => 'Game', :foreign_key => 'winner_id'

  attr_accessible :email, :password, :password_confirmation, :username

  validates :email,    :presence => true,
                       :uniqueness => { :case_sensitive => false },
                       :format => { :with => EMAIL_REGEX } 
  validates :username, :presence => true,
                       :uniqueness => { :case_sensitive => false }
  validates :password, :presence => true
  has_secure_password

  before_save { self.email.downcase! }
  before_save { self.username.downcase! }

  def games
    Game.where("player1_id OR player2_id = ?", self.id)
  end

end
