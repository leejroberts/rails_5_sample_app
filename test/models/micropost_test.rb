require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  # creates a fake user and micropost from the fixtures to test against
  def setup
    @user = users(:michael)
    # below makes a new micropost associated with 'michael' from the fixtures
    @micropost = @user.microposts.build(content: "lorem ipsum") 
    #.build method. see NOTES/relationship.text for further info
  end

  #checks that the default post in setup is valid, which it is so it should pass
  test "should be valid" do
    assert @micropost.valid?
  end
  
  # makes sure that there is a user associated with the post
  test "user id should be present" do
    @micropost.user_id = nil #sets user ID to nil or noting
    assert_not @micropost.valid? #checks that the micropost is invalid with no user ID
  end
  
  # makes sure that there is content in a post
  test "content should be present" do
    @micropost.content = " "
    assert_not @micropost.valid?
  end
  
  #makes sure that the posts are less than 140 characters
  test "content should be at most 140 characters" do
    @micropost.content = 'a' * 141
    assert_not @micropost.valid?
  end
  
  test 'order should be more recent first for microposts' do
    assert_equal microposts(:most_recent), Micropost.first
  end
  
  
  
end
