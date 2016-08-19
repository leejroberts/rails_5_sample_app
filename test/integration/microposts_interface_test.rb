require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end
  
  test 'micropost interface' do
    log_in_as(@user) #log in as michael
    get root_path #go to the home page
    assert_select 'div.pagination' #checks that there is pagination aka that
    # aka that the user specific home page with posts shows up, not the sign up page
    #invalid submission
      # checks that the count of the microposts doesn't change with a blank post
    assert_no_difference 'Micropost.count' do 
      post microposts_path, params: { micropost: { content: ''}}
    end
    assert_select 'div#error_explanation'
    #valid submission
     # checks that the microposts count increases by 1 with a valid post
    content = 'this micropost really ties the room together' #variable name content with valid content
    assert_difference 'Micropost.count' , 1 do #checks that there is a +1 difference
      post microposts_path, params: { micropost: { content: content }} #when valid content is posted
      # note: above^ inserts variable NAMED content into the content attribute/db column of micropost
    end
    assert_redirected_to root_url #once posted, user should go back to the root url
    follow_redirect! #test follows the user to root_url
    assert_match content, response.body #checks that the content variable is found somewhere on the page
    
    # delete post 
    assert_select 'a', text: 'delete' #looks for link for delete
    first_micropost = @user.microposts.paginate(page: 1).first #sets the first existing micropost to var first_micropost
    assert_difference 'Micropost.count', -1 do #checks that the count of microposts decreases by 1
      delete micropost_path(first_micropost) #when the first micropost is deleted
    end
    #visit different user(no delete links)
    get user_path(users(:archer)) #goes to archer page as michael
    assert_select 'a', text: 'delete', count: 0 # looks for a hrefs with text delete
    #since you are michael(in this case) there should be no delete links
  end
  
end
