class User < ActiveRecord::Base
  attr_accessor :remember_token  # Listing 8.32

  before_save { self.email = email.downcase } # callback that downcases email address of current user before saving to db.
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 }
  # Regex -- Listing 6.21 from book
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  # Replace 'true' with 'case_sensitive: false' -- rails infers that it is true as well
  validates :email, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 6 }, allow_blank: true # allow_blank -- Listing 9.10

  # Listing 8.18
  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Listing 8.31
  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Listing 8.32
  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Listing 8.33
  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    return false if remember_digest.nil?  # Listing 8.45
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Listing 8.38
  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end
end
