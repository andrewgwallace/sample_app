class StaticPagesController < ApplicationController

  def home
  	# @micropost = current_user.microposts.build if logged_in? # Listing 11.38
  	if logged_in?
  		@micropost 	= current_user.microposts.build
  		@feed_items = current_user.feed.paginate(page: params[:page]) # Listing 11.45
  	end
  end

  def help
  end

  def about
  end

  def contact
  end
end
