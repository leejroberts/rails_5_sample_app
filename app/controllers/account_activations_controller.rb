class AccountActivationsController < ApplicationController
  
  #checks to see if the user is activated; if not, activates them
  def edit
    user = User.find_by(email: params[:email]) #sets a local variable user by the email
    if user && !user.activated? && user.authenticated?(:activation, params[:id]) 
    # if user exists and is not activated and is authenticate
      user.activate #method in User model; relocates two lines of code for speed
      log_in user
      flash[:success] = "Account activated!" 
      redirect_to user
    else #handles invalid activation links
      flash[:danger] = "Invalid activation_link"
      redirect_to root_url
    end
  end
  
end
