module SessionsHelper

  # Listing 8.12
  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
  end

  # Listing 8.35
  # Remembers a user in a persistent session.
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Listing 8.14 -- Only knows about temporary session.
  # def current_user
  #   @current_user ||= User.find_by(id: session[:user_id])
  # end


  # Listing 9.24
  # Returns true if the given user is the current user.
  def current_user?(user)
    user == current_user
  end

  # Listing 8.36
  # Returns the user corresponding to the remember token cookie.
  def current_user
    if (user_id = session[:user_id]) #   Reads: "If session of user id exists (while setting user id to session of user id)""
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token]) # cookies[:remember_token]) -- Previous method from Listing 8.43
        log_in user
        @current_user = user
      end
    end
  end

  # Listing 8.15
  def logged_in?
    # This reads, "If the current user is not nil, return true."
    !current_user.nil?
  end

  # Listing 8.39
  # Forgets a persistent session.
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Listing 8.26
  #Logs out the current user.
  def log_out
    forget(current_user)  # Listing 8.39
    session.delete(:user_id)
    @current_user = nil
  end

  # Listing 9.27
  # Redirects to stored location (or to the default).
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.url if request.get?
  end
end
