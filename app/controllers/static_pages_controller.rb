class StaticPagesController < ApplicationController
  
  #static_pages/home is root_url
    #if user has an account+logged-in, user sees
     #user info, small gravatar, most recent microposts, 
     # form to make new microposts
   #if not logged in will see sign-up page
  def home
    if logged_in? #checks for log-in
      @micropost = current_user.microposts.build #instance variable for new micropost
      @feed_items = current_user.feed.paginate(page: params[:page])#note: .feed, paginate
    end #if not logged in page is static, no access needed
  end

  def help
  end
  
  def about
  end
  
  def contact
  end
end
=begin NOTES:

  .feed method 
    pulls microposts from the logged-in users db
    located in User model
    
  .paginate method
    derived from the pagination gem.
    not a built in method.

  current_user defined in sessions_helper
 
  logged_in? defined in sessions_helper
 
=end
