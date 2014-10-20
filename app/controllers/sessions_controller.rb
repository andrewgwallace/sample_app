class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Log the user in and redirect to the user's show page.
      # Listing 8.13 -- 'log_in' method defined within the session_helper.rb file.
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)  # Listing 8.49
      # remember user  # Listing 8.34 (Before "remember checkbox")
      redirect_to user   #Rails converts to this to the route for user's profile page: user_path(user)
    else
      # Create an error message.  Listing 8.9.
      flash.now[:danger] = 'Invalid email/password combination' #Not quite right!
      render 'new'
    end
  end

  def destroy
    # log_out  #Listing 8.27
    log_out if logged_in? # Listing 8.42
    redirect_to root_url
  end
end
