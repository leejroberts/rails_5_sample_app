# Preview all emails at http://rails-5-hartl-leejamesroberts.c9users.io:8080/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://rails-5-hartl-leejamesroberts.c9users.io:8080/rails/mailers/user_mailer/account_activation
  def account_activation
    user = User.first #creates a user to attempt to activate
    user.activation_token = User.new_token #assigns them an activation token...they don't have one bc they didn't just go through the account setup procedure.
    UserMailer.account_activation(user) #we created a user bc account_activation requires a user
  end

  # Preview this email at http://rails-5-hartl-leejamesroberts.c9users.io:8080/rails/mailers/user_mailer/password_reset
  
  #NOTE: UserMailerPreview is kinda like a test suite in an odd way.
    ## for this reason you may define and call a method (with the same name) twice in a row (see below)
    ## first you define the method for the UserMailerPreview
      ## then you call a method of the same name
  
  #NOTE: these two password_resets are NOT the same method!
  def password_reset #defining method for UserMailerPreview
    UserMailer.password_reset #calling a method WITH THE SAME NAME from UserMailer 
  end 
end

