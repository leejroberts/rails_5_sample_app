require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper #this gives the integration test access to the
  #full_title method
  
  def setup
    @user = users(:michael)
  end
  
  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name) #checks that the full title works
    assert_select 'h1', text: @user.name #checks that the name is in the h1
    assert_select 'h1>img.gravatar' #note
    assert_match @user.microposts.count.to_s, response.body #note below
    assert_select 'div.pagination' #checks that there is a div with CSS class paginate
    @user.microposts.paginate(page: 1).each do |micropost| 
      assert_match micropost.content, response.body #note 
    end
  end
end
=begin
 Note:
  assert_select 'h1>img.gravatar' (notice the > )
    this checks for an img tag with a class of gravatar inside an H1 tag.(notice the > )
 
  response.body checks the entire html content for something, not just the body
    assert_match @user.microposts.count.to_s, response.body
      the assertion above checks that the micropost count is somewhere in the html
      it doesn't specify where, which is useful (due to the possibility of changes to the html)
    
  assert_select is more specific to location
    ex: assert_select 'h1', text: @user.name specifically checks just h1 for the users name
    
  assert_match micropost.content, response.body
    this line checks that, as you iterate through the microposts, the content of the post is found somewhere 
    in the html
    this works as a test bc the Faker::Lorem method was invoked (which generates relatively random text).
    this means that all of the microposts content can be checked for
=end
