# Listing 11.32
class MicropostsController < ApplicationController
	before_action :logged_in_user, only: [:create, :destroy]
	before_action :correct_user, 	 only: :destroy # Listing 11.50

	def create
		# Listing 11.34
		@micropost = current_user.microposts.build(micropost_params)
		if @micropost.save
			flash[:success] = "Micropost created!"
			redirect_to root_url
		else
			@feed_items = [] # Listing 11.48
			render 'static_pages/home'
		end
	end

	def destroy # Listing 11.50
		@micropost.destroy
		flash[:success] = "Micropost deleted"
		redirect_to request.referrer  || root_url
	end

	# Listing 11.34
	private

		def micropost_params
			params.require(:micropost).permit(:content, :picture) # Listing 11.58 - ':picture' added.
		end

		# Listing 11.50
		def correct_user
			@micropost = current_user.microposts.find_by(id: params[:id])
			redirect_to root_url if @micropost.nil?
		end
end
