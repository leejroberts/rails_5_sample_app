class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy
  
  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url #sends you to StaticPagesController#home
    else
      @feed_items = [] #NOTE!!! very important!!!
      render 'static_pages/home' #this directly renders the static_pages/home VIEW
    end
  end
  #
  #destroys the micropost and redirects you
  #request.referrer sends you back to the url you just came from
  def destroy
    @micropost.destroy
    flash[:success] = 'Micropost deleted'
    redirect_to request.referrer || root_url
    #redirect_to where you came from if nil, root_url
  end
  
  private
  
  def micropost_params
    params.require(:micropost).permit(:content, :picture)
  end
  
  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to root_url if @micropost.nil?
  end
end
=begin NOTES: (logged_in_user, oddball empty array assignment! )

logged_in_user 
  location: APPLICATION controller 
  reason: used in both microposts_controller and users_controller
    both can access due to structure of inheritance
    
@feed_items = [] (why this is necc.)
  the empty array assignment of @feed_items is to bypass an issue
  with failed micropost submissions
  without the empy array assignment, users get an error from the _feed partial
    aka the psuedo-feed partial
  
  with unsaved microposts (failed submissions), the code directly renders 'staticpages/home' view 
  without going through the StaticPagesController 
    due to this, the @feed_items variable is never set
    and the user will get a nil class failure @user_items = nil class? 
    thus you set @feed_items == to an empty array
      @feed_items = []
    somehow, rails fills it back in with the previous content?
    hash_tag "rails magic" lol
    
@feed_items (alternate lee solution).
  repalce the render command with a redirect_to command
    thus regardless of the creation of a new micropost, it retrieves the data
    for the microposts feed partial
 
 
 
=end
