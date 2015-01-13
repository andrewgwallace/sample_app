class RelationshipsController < ApplicationController
	before_action :logged_in_user # Listing 12.31

	# Listing 12.32 - Commented out in favor of Ajax requests in Listing 12.35.
	# def create
	# 	user = User.find(params[:followed_id])
	# 	current_user.follow(user)
	# 	redirect_to user
	# end

 #  def destroy
 #    user = Relationship.find(params[:id]).followed
 #    current_user.unfollow(user)
 #    redirect_to user
 #  end

 	# Listing 12.35 - Responding to Ajax requests.
	def create
		@user = User.find(params[:followed_id])
		current_user.follow(@user)
		respond_to do |format|
			format.html { redirect_to @user }
			format.js
		end
	end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    respond_to do |format|
    	format.html { redirect_to @user }
    	format.js
    end
  end
end
