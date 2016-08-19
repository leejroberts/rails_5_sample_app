require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @micropost = microposts(:orange)
  end
  
   #checks that there is no difference in the count of the microposts if user
   ## tries to post when user is not logged in
  test "should redirect create when not logged in" do
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "Lorem ipsum"}}
    end
    assert_redirected_to login_url
  end
  
  # does the same as above to check that there is no change if a user tries to
   ## delete a post when they are not logged in
  test 'should redirect destroy when not logged in' do
    assert_no_difference 'Micropost.count' do
      delete micropost_path(@micropost)
    end
    assert_redirected_to login_url
  end
  
  #test checks that user A (:michael) can't delete the posts of user B (:archer)
    ## posts are defined in the microposts fixture
  test "should redirect destroy for wrong micropost" do
    log_in_as(users(:michael))
    micropost = microposts(:ants)
    assert_no_difference 'Micropost.count' do
      delete micropost_path(micropost)
    end
    assert_redirected_to root_url
  end
  
end
