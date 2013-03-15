class User < ActiveRecord::Base
  EMAIL_REGEX = /.+@.+\..+/

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

end
