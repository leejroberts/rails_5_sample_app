class RelationshipsController < ApplicationController
  before_action :logged_in_user
  
  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
  #destroys a follow relatonship
  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end

=begin NOTE
  the user in the create and destroy actions for the relationship is the OTHER USER
  current_user is user (as we are used to using it)
  the followed_id is set in forms _follow _unfollow located in view/users
=end


