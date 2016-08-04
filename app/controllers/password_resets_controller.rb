class PasswordResetsController < ApplicationController
  before_action :get_user,         only: [:edit, :update] # gets the user
  before_action :valid_user,       only: [:edit, :update] # checks for valid user
  before_action :check_expiration, only: [:edit, :update] # checks expiration of reset token
  
  # renders the form to enter an email address to send the password reset link to
  def new
  end
  
  # sends the password reset link
    ## finds user by the email entered in the from
    ## generates reset digest
    ## sends email with link (if all successful)
  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase) #.downcase doesn't seem to work here...
    if @user #if user is found in db by the password they entered in the form
      @user.create_reset_digest #method defined in user model
      @user.send_password_reset_email #method defined in user model
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url #sends them back to the home page
    else #user not found by the email addy they entered
      flash.now[:danger] = "Email address not found"
      render 'new' #renders the new view again
    end
  end
  
  # renders the form to update/reset the password
    ## clicking on link in email sends you to this action
  def edit
  end
  
  # updates the password reset
  # before_action makes sure reset_token is not expired
  def update
    if params[:user][:password].empty? #checks for attempt to update with blank password
      @user.errors.add(:password, "can't be empty") 
      render "edit" #if the password fields are blank, password edit page is re-rendered
    elsif @user.update_attributes(user_params) #checks for successful update of attributes
      log_in @user #if update is successful, user is logged in
      flash[:success] = "password has been reset" #success message is flashed at top of screen
      redirect_to @user #sends user to their user page (user#show)
    else 
      render 'edit' #if not successful, re-renders the password edit page
    end
  end
  
  private
    
    #sets hard parameters for the password reset 
      ## does not contain name and email like the user controller user_params
      ## this is bc these things should not be set via the password reset
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end
    
    # before_actions are below
    
    # retrieves user from the DB by email address
    def get_user
      @user = User.find_by(email: params[:email]) #finds user by email in the params of the request
    end
    
    # before_action that checks for a valid user
    # unless the user is found, is activated, and authenticated via the reset_token
      ## the user will be sent to the root_url (the welcome page)
    # so, if all these things are true you move along to the next chunk of code
    def valid_user
      unless (@user && @user.activated? &&
              @user.authenticated?(:reset, params[:id])) 
      redirect_to root_url
      end
    end
    
    # checks for expired password reset_token before allowing password reset 
    def check_expiration
      if @user.password_reset_expired? #def in User model, if expired...
        flash[:danger] = 'Password reset has expired.' #flashes warning
        redirect_to new_password_reset_url #sends user back to password reset action
      end
    end
end
