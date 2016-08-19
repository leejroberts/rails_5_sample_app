class UsersController < ApplicationController
  #before_actions; rails method used to make sure something has happened first
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy] #confirms user logged in before the actions to the right
    ##important: logged_in_user moved to APPLICATION_CONTROLLER see note:
  before_action :correct_user,   only: [:edit, :update] #confirms user is attempting to edit/update self
  before_action :admin_user,     only: :destroy
  
  #Note: that many of these methods create an instance variable @user; 
  
  #routes to user/show to show the currently logged in user
  ## displays all the microposts in pages from most recent to least recent
  
  def show
    @user = User.find(params[:id])#finds user by the id parameter; creates an instance of the user 
    @microposts = @user.microposts.paginate(page: params[:page])
  end
  
  def new
    @user = User.new #creates a new instance of user class
  end
  
  # returns the index view to the browser; populated with all the users in pages of 30 users
  def index
    @users = User.paginate(page: params[:page]) #uses paginate gem to create a lists of users separated into pages by groups of 30
  end
  
  # Saves instance of User to the database; 
  # if save successful; routes to user homepage w/ welcome message 
  def create
    @user = User.new(user_params)
    if @user.save #implied boolean check
      @user.send_activation_email #original code relocated to user model in this method
      flash[:info] = "Please check your email to activate your account." #pop_up to create user message
      redirect_to root_url #sends you back to the root_ufrl aka "welcome page"
      ##code below is for a user sign-up without email activation being sent
        ## log_in @user #logs in the newly created user... 
        ## flash[:success] = "Welcome to the Sample App!" #and show this message
        ## redirect_to @user #renders view/user/show
    else #if @user.save != true
      render 'new' #renders view/user/new; the sign-up form
    end
  end
  
  # has before_action methods: logged_in_user, correct_user 
  def edit
    # @user = User.find(params[:id]) <-- not needed; @user defined in correct_user
  end
  
  # has before_action methods: logged_in_user, correct_user 
  def update
    # @user = User.find(params[:id]) <-- not needed; @user defined in correct_user 
    if @user.update_attributes(user_params)
      flash[:success] = "Profile Updated"
      redirect_to @user
      # handle this later
    else
      render "edit"
    end
  end
  
  #before_action: logged_in_user, admin_user
  def destroy
    User.find(params[:id]).destroy #finds the user to destroy by ID and deletes them
    flash[:success] = "User Deleted" # if successful delete message flashed to screen
    redirect_to users_url #redirects back to the index of all users
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  
  
  
  private #the private section defines methods accessed within rails; used for security

    def user_params #defines what user attributes can be edited and accessed by the user
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    # before filters: makes sure something has happened before something else
    
    
    # confirms that the user
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user) #checks if current_user == @user
      #current_user? defined in session helper
    end
    
    def admin_user
      redirect_to(root_url) unless current_user.admin? #sends users back to the root_url unless they are admin users
    end
end
=begin

  Note:
  logged_in_user (before action) has been moved to application_controller
    reason: both microposts_controller and users_controller need access to the method
   
module SessionsHelper 
  methods listed below
  
    def logged_in?
       !current_user.nil?
    end

=end