require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  # Notes at end on .clear .reload and assign
  def setup
    ActionMailer::Base.deliveries.clear #this is needed to clear the memory of the emails sent
  end
  
  test 'invalid signup information' do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: "", 
                                        email: 'user@invalid', 
                                     password: "foo", 
                        password_confirmation: "bar" } }
    end
    assert_template 'users/new'
    assert_select "div#error_explanation"
    assert_select "div.field_with_errors"
  end
  
  test 'valid signup information with account activation' do
    get signup_path
    assert_difference "User.count", 1 do
      post users_path, params: { user: { name: "Example User", 
                                        email: "user@example.com",
                                     password: "password",
                        password_confirmation: "password" } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size # .size counts the number of email deliveries
    user = assigns(:user) # assigns method finds a user instance in the corresponding class (see note bottom)
    assert_not user.activated?
# Try to log in before activation
    log_in_as(user)
    assert_not is_logged_in?
# attempting activation with invalid activation_token
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?
# attempting activation; valid activation_token, wrong email
    get edit_account_activation_path(user.activation_token, email: "wrong")
    assert_not is_logged_in?
# activate with_valid activation token and correct email
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated? #this needs to be reloaded bc the user is in memory, not in the database
    follow_redirect! #not sure why ! is here...
    assert_template 'users/show'
    assert is_logged_in?
  end
end
=begin 

all below this point are comments

.reload: seems to have many uses, particulary in the test suite 
  does exactly what it says
  in testing, makes sure the data you are testing against is current
  
.clear: used extensively in testing to clear ActionMailer's memory.
  likely has other uses / locations it can be used
  similar to reload, used to make sure data tested against in current
    not testing old sent emails etc.
  
  clearing ActionMailers memory below, useful!
    ActionMailer::Base.deliveries.clear
  
  assigns method:  to assign things to things. 
    from the test suite it needs to have an idea of "where you are"
      aka what controller you are using! otherwise it does not work!
    
=end