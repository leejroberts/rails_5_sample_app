module SessionsHelper

  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
  end

  # Remembers a user in a persistent session.
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  # Returns true if the given user is the current user
  def current_user?(user)
    user == current_user #current_user method defined below
  end
  
  # PREVIOUS current_user method (left just in case)
  # Returns the current logged-in user (if any).
  # def current_user
  #   @current_user ||= User.find_by(id: session[:user_id])
  # end
  
  def current_user
    if (user_id = session[:user_id]) #checks that the user id matches the session id
      @current_user ||= User.find_by(id: user_id) #if that is true, it sets @current_user to the user with the matching id
    elsif (user_id = cookies.signed[:user_id]) #does the same thing with cookies
      user = User.find_by(id: user_id) 
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end
  
  #forgets a persistent session, aka deletes the cookies of the user ID and the remember_token
  def forget(user)
    user.forget #this is interesting...might be a rewrite to allow class method style call
    cookies.delete(:user_id) 
    cookies.delete(:remember_token)
  end

  # Logs out the current user.
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
  
  # Redirects to stored location (or to the default)
  def redirect_back_or(default)
    redirect_to ( session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end
  
  #stores a URL trying to be accessed; used to return to URL after sign in/other necc step.
  def store_location
    session[:forwarding_url] =request.original_url if request.get?
  end
end