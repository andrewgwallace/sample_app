class AccountActivationsController < ApplicationController
  
  # Listing 10.27
  def edit 
  	user = User.find_by(email: params[:email])
  	if user && !user.activated? && user.authenticated?(:activation, params[:id])
  		user.activate # Listing 10.33
  		# user.update_attribute(:activated,	 true) 					# REMOVED in Listing 10.33 (Refactoring)
  		# user.update_attribute(:activated_at, Time.zone.now)		# REMOVED in Listing 10.33 (Refactoring)
  		log_in user
  		flash[:success] = "Account activated!"
  		redirect_to user
  	else
  		flash[:danger] = "Invalid activation link"
  		redirect_to root_url
  	end
  end

end
