
require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
# BEGIN -- Listing 11.2 (To be fixed in section 11.1.3)
	def setup
		@user = users(:michael)
		#This next line of code is not idiotmatically correct
		# @micropost = Micropost.new(content: "Lorem ipsum", user_id: @user.id)
		@micropost = @user.microposts.build(content: "Lorem ipsum")
	end

	test "should be valid" do 
		assert @micropost.valid?
	end

	test "user id should be present" do 
		@micropost.user_id = nil
		assert_not @micropost.valid?
	end
# END -- Listing 11.2

# BEGIN -- Listing 11.6
	test "content should be present" do 
		@micropost.content = "	  "
		assert_not @micropost.valid?
	end

	test "content should be at most 140 characters" do 
		@micropost.content = "a" * 141
		assert_not @micropost.valid?
	end
# END = Listing 11.6

	# Listing 11.13
	test "order should be most recent first" do 
		assert_equal Micropost.first, microposts(:most_recent)
	end
end
