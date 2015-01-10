class Micropost < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order(created_at: :desc) } # Listing 11.16
  mount_uploader :picture, PictureUploader # Listing 11.56
  validates :user_id, presence: true #Listing 11.4
  validates :content, presence: true, length: { maximum: 140 } # Listing 11.7
  # BEGIN Listing 11.61
  validate :picture_size # Note the use of validate (as opposed to validates) to call a custom validation.

  private

  	# Validates the size of an uploaded picture.
  	def picture_size
  		if picture.size > 5.megabytes
  			errors.add(:picture, "should be less than 5MB")
  		end
  	end
  	# END Listing 11.61
end
