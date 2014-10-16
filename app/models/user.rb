class User < ActiveRecord::Base
  before_save { self.email = email.downcase } # callback that downcases email address of current user before saving to db.
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 }
  # Regex -- Listing 6.21 from book
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  # Replace 'true' with 'case_sensitive: false' -- rails infers that it is true as well
  validates :email, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 6 }
end
