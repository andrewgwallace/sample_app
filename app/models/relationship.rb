class Relationship < ActiveRecord::Base
	# BEGIN - Listing 12.3
	belongs_to :follower, class_name: "User"
	belongs_to :followed, class_name: "User"
	# END - Listing 12.3
	# BEGIN - Listing 12.5
	validates :follower_id, presence: true
	validates :followed_id, presence: true
	# END - Listing 12.5
end
