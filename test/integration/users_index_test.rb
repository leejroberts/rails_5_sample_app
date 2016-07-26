require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:michael) #calls michael from fixtures admin: true
    @non_admin = users(:archer) #calls archer from fixtures admin: nil
  end
  
  #NOTE!!! for pagination test to work, you must have more than 1 page worth of users. 
    # pagination currently occurs at 30
    # you need 31 users for pagination
    # fake users set in fixtures
    
  test "index as admin including pagination and delete links" do
    log_in_as(@admin) #login as admin
    get users_path # gets the userS(note the plural) path which should take us to the index page 
    assert_template 'users/index' #assert_template is asserting that we showed the proper page/template, users/index 
    assert_select 'div.pagination' #checks that there is a html div with class paginations <div class="pagination"> 
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user| #iterating through all the users on page 1
      assert_select "a[href=?]", user_path(user), text: user.name # tests that each user links back to their user page and it has their name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete' # tests that there are delete links for all the users IF current user is admin
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin) #remember...there is no database, so you're deleting the other entry
    end
  end
  
  test 'index as non-admin' do
    log_in_as(@non_admin)
    get users_path #this requests to view the users index
    assert_select 'a', text: 'delete', count: 0 #checks that there are zero a (hyperlink)
    #tags with the text delete aka delete links are not showing
  end
end

