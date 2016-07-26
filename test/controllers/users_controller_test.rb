require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  
  def setup #calls a fake user "Michael" from test/fixtures/user.yml
    @user = users(:michael) #gives the tests a user, DOES NOT SIGN THE USER IN
    @other_user = users(:archer) #calls a second fake user "archer" from test/fixtures/user.yml
  end   
  
  #tests that the user is lgged in to view the index of users
  test "should redirect index when not logged in" do
    get users_path #requests views/users/index
    assert_redirected_to login_url
  end
                            
  
  #test of signup_path, does not require a user bc they are entering for the first time AKA signing-up
  test "should get new" do
    get signup_path #requests the sign-up page
    assert_response :success #checks that sign-up page results
  end
  #Group below requires a user to attempt to edit and update, defined in setup ^^^
  
  #tests that you can't edit a user's info if you're not logged in
  test "should redirect edit when not logged in" do
    get edit_user_path(@user)#requests to edit user (pulled in from setup),  NOT while logged in
    assert_not flash.empty? #there should be a flash message _not +.empty? translates to not empty or full
    assert_redirected_to login_url #before_action ?not sure what this note means
  end
  
  #tests that you can't update a user's info when not logged in
    #if update is attempted while not logged in, user should be routed to log in page
  test "should redirect update when not logged in" do
    patch user_path(@user), params: { user: { name: @user.name,
                                            email: @user.email }}#tries to update; not logged in
    assert_not flash.empty?
    assert_redirected_to login_url #checks that the above action is re-routed to login page
  end 
  
  # testing to make sure user X can't edit user y
  # the user data for
  test "should redirect edit when logged into the wrong user" do
    log_in_as(@other_user) #"user X"
    get edit_user_path(@user) #attempting to edit "user Y"
    assert flash.empty?
    assert_redirected_to root_url #checks that in the case above, you are redirected to root_url
  end
  
  #tests to make sure user X can't update user Y
  test "should redirect update when logged into the wrong user" do
    log_in_as(@other_user) #"login in as user X"
    patch user_path(@user), params: { user: { name: @user.name,
                                            email: @user.email }} # tries to update user Y; 
                                                                  # logged in as user X
    assert flash.empty? #there should be no flash message. .empty? == true
    assert_redirected_to root_url #checks that (in the case above) you are redirected to login page
  end
  
  # Destroy action tests
  
  # if a non logged in user submits a destroy request, they should be routed to the welcome page
  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do #checks that the count of users has not changed when (below)
      delete user_path(@user) #submits a destroy request to the user path
    end
    assert_redirected_to login_url
  end
  # if a logged in non-admin user tries to issue a destroy command
  test "should redirect destory when logged in as a non-admin" do
    log_in_as(@other_user) #logs you in as other user "Archer"
    assert_no_difference "User.count" do #checks that there is no difference in user count after (below)
      delete user_path(@user) #submits a destroy request
    end
    assert_redirected_to root_url #checks that you are re routed the the root url
  end
end
