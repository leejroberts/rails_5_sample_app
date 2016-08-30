class User < ApplicationRecord 
  #see file NOTE/relationship.text
  has_many :microposts, dependent: :destroy #gives the user many posts, 
  # destroys user microposts with destruction of user (by admin)
  
  # the odd syntax below is related to the fact that active_relationships
    ## is not a model. 
  has_many :active_relationships, class_name: "Relationship", #tells rails where to look (in the Relationship class or model)
                                  foreign_key: 'follower_id', #I believe this automatically sets the user_id to the follower_id
                                  dependent: :destroy #if the user is destroyed all other their active_relationships are destroyed
  has_many :following, through: :active_relationships, source: :followed 
  #source: is needed bc the followed and following aren't plural/singular of one another so their relationship has to be stated explicitly
  # if instead has_many :followeds  rails could figure this out but it looks really odd to humans
  
  
  has_many :passive_relationships, class_name: 'Relationship',
                                  foreign_key: 'followed_id',
                                  dependent: :destroy #if the user is destroyed, all of their passive relationships are destroyed 
                                  #(a user can't follow a non-existant other user)
  has_many :followers, through: :passive_relationships, source: :follower 
  #source isn't actually needed in this line bc follower and followers line up
                                  
   #NOTE: attr_accessor!!!
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save   :downcase_email             # calls method(s) before saving to DB
  before_create :create_activation_digest   # before instantiation AND save (double check this)
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # Returns the hash digest of the given string using Bcrypt.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end #above^ BCrypt(ic) Hartl does not explain the code, but it works

  # Returns a random token. used for All TOKENS remember, activate, reset
  def User.new_token
    SecureRandom.urlsafe_base64 #generates a string of random characters
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  #NOTE: .send method, meta programming
  def authenticated?(attribute, token)        #token can be ANY token
    digest = self.send("#{attribute}_digest") #interpolates attribute w/ _digest ex: => remember_digest
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  #forget sets remember_digest to null, thus they are 'forgotten'(no longer auto-logged in)
    #why this works...
      # previously, remember_digest stored in db; remember_token stored in browser
      #if above are matched(via bcrypt), user is auto-logged in.
  def forget
      update_attribute(:remember_digest, nil) 
  end                                         
  
  # activates an account; code was cut out of the controller and moved here for speed
  def activate
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end
  
  # sends activation email...like the man said 
  def send_activation_email
    UserMailer.account_activation(self).deliver_now #deliver_now is a rails method (i think)
  end
  
  #Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end
  
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # returns true if a password reset has expired
    # syntax is odd, but it checks if the password was sent more than 2 hours ago
  def password_reset_expired?
    reset_sent_at < 2.hours.ago 
  end
  
  #defines a feed used for the home page(if user is logged in)
    # supplies a list of recent microposts by the user and those the user follows
    # => static_pages/root_url thus => shared/_feed (partial then rendered on the home page)
    # this uses an SQL subselect see hartl chapter 14 section 14.3.3
    # summary subselects are more effecient for large database queries
    # they put the result of the subselect into the database, rather than into the working memory
  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end

  
  #following, unfollow etc other users
  
  # checks if user is following another user
   # self. can be excluded bc we are in the model but i left it for clarity
   # the "following" method is derived from has_many :following...at top
   # following gives you access to the list of followers
  def following?(other_user)
    self.following.include?(other_user)
  end
  
  # creates the following relationship aka follows the microposts of another user
    # it creates an active_relationship (vs a passive relationship)
    # sets the user_id of the other user to followed id
    # aka other_user.id == followed_id
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end
  
  # unfollow method explanation 
   # finds the active relationship via the other user's id
   # there is an understood self. before active_relationships.find_by...
   # thus translated;
    # find a relationship where the follower_id is the current user
    # and the followed_id is the id of the user from the 'argument'
    
  # __THE COMMENTED OUT METHOD BELOW CALLS calls unfollow__
  # Destroy method is in the relationships controller
  #   def destroy
  #     other_user = Relationship.find(params[:id]).followed 
  #     current_user.unfollow(other_user)
  #     redirect_to user
  #   end
  
  # Unfollows a user.
  def unfollow(other_user)
    self.active_relationships.find_by(followed_id: other_user).destroy
  end
    
  private
  
    #converts email to all lowercase for ease of comparison/checking/finding user
    def downcase_email 
      self.email = email.downcase
    end
    
    #Creates and assigns the activation token and digest
    def create_activation_digest
      self.activation_token = User.new_token#method above
      self.activation_digest = User.digest(activation_token)
    end  
   
end
=begin Notes: attr_accessor, .where method, virtual attributes, 
              .send method, meta-programming

att_accessor: 
    is being used to accessing VIRTUAL ATTRIBUTES (this is often the case in rails)

.where method:
    similar to sql where is used to add selection criterion to a db
    in this particular case...
      Micropost.where("user_id = ?", id)
      the where method is used to escape an sql injection. 
      the question mark is a part of this
      
Virtual attributes:
  attribute data stored in temp storage, but not commited to the database
  they are accessed 'ruby style' via att_accessor

usage in this case for attr_accessor
  The remember_token and the activation_token are not going into the database directly
  they will be stored in the cookies or sent in an email for activation 
  the remember_digest and activation_digest ARE going into the database
  So, the encrypted version is stored in the database and the non encrypted version
  is sent out into the world.
      

.send method
  .send lets you call instance methods as variables like in regular methods

  array = [1, 2, 3,]
  
  array.length => 3
  array.send('length') => 3
  array.send(:length) => 3
  array.send("#{len}gth") => 3 notice; "#{len}gth" is intepreted into length. 
                                        returning the same result
  
  contrived example of a way to use this
    you could call different things; same method
    
  def method(var, array)          
    array.send("#{var}gth")       
  end
   
  method(len, [1, 2, 3]) => 3

=end