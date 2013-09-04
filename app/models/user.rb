class User < ActiveRecord::Base
  belongs_to :endorsement

  validates :password, presence: true, on: :create
  before_save :encrypt_password

  attr_accessor :password

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
end
