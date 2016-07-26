class SessionsController < ApplicationController

  def new #creates a new Session, not a new user or instance of user in controller...
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user) # see note below
      redirect_back_or user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy #ends the session logs you out
    log_out if logged_in? #logout < sessions helper; removes ID and _token from cookies
    redirect_to root_url
  end
end

#Sessions Helper:
  # def log_out
  #   forget(current_user) ##forget<sessions helper current user from the cookies (I think)
  #   session.delete(:user_id) ##deletes session information for the current user
  #   @current_user = nil
  # end

#ternary operator explaination:
  # ternary operator notation:
    # params[:session][:remember_me] == '1' ? remember(user) : forget(user)
  
  # Non-ternary operator notation; code has same result
    # if params[:session][:remember_me]=='1'
    #   remember(user)
    # else
    #   forget(user)
    # end