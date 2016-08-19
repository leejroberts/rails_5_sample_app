class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  
  protect_from_forgery with: :exception
  include SessionsHelper
  
  private
  
   # confirms a logged in user
    def logged_in_user
      unless logged_in?#Sessions Helper Method; returns boolean if user is/is not logged in
        store_location #Sessions Helper method; stores the URL trying to be accessed
        flash[:danger] = "Please log in." #logged_in? == false; red log-in message 
        redirect_to login_url #logged_in? == false; routes view to login page
      end
    end
end
