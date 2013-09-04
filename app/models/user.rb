class User < ActiveRecord::Base
  belongs_to :endorsement

  #validates :password, presence: true, on: :create
  before_save :encrypt_password

  attr_accessor :password
  
  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  def password_blank?
    (password_salt.blank? && password_hash.blank?) ? true : false
  end
end
