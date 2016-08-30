Rails.application.routes.draw do
  
  get 'password_resets/new'

  get 'password_resets/edit'

  # Note about routes
    ## you can route ANY url to ANY controller action
    
    ## THE URL AND THE ACTION DO NOT HAVE TO MATCH IN ANY WAY! (but they can and often are relatedish)
    
    ## as long as you use the syntax starting on line 12
    ## as follows 
      ## browser request '/stuff', to: 'controller name#action'
      ## EX: get '/help', to: 'static_pages#help' routes the url https://exampleurl/help => the static pages controller action help
      ## also, this would create a helper methods help_path and help_url
      ## use _path methods for link_to (likely others but this one for sure)
      ## use _url methods for redirect_to (possibly other, but this one for sure)
      
  #Note on root
    ## setting the root makes the first page you see whatever controller and action you prefer
    ## it creates a root_path and root_url helper method
    ## root_path just returns a slash / that does not show up in the brower address bar
    ## root_url needs to be used with redirect_to (possibly others but this one for sure)
    
  #Note on Http requests [get update post patch delete]
    ## get is the default, if you don't specify it sends a get request
    ## post puts in new information 
      ## EX: form_for for a new user will have a submit button
      ## the submit button will by default submit a POST request
    
      
  
  get 'sessions/new'
  get 'users/new'#not sure if this is still needed
  root 'static_pages#home' 
  
  # actions for the static pages
  get  '/help', to: 'static_pages#help' #Note you can route anything to anything
  get  '/about', to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact' 
  get '/signup', to: 'users#new'
  
  # actions for the session
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: "sessions#destroy"
  
  # actions for user
   # this code give the normal resources for users and adds on following and followers
   # the url will be ...users/id_num/followers (for followers)
   # IMPORTANT see note for syntax without the user id added in.
  resources :users do
    member do #this part adds in the /user_id/
      get :following, :followers
    end
  end
   # actions for account activation
  resources :account_activations, only: [:edit] #this edits resources to only include the edit feature
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :destroy] #new and update were not added bc microposts will be added
  resources :relationships,       only: [:create, :destroy] #adds the ability to create and destroy relationships (aka active_relationships and passive_relationships)
  # and edited through the user homepage (so we don't need new views)
=begin Note:
 syntax for adding to resources WITHOUT having the user_id in the url users/tigers vs users/user_id/tigers
 
resources :users do
  collection do
    get :tigers
  end
end

=end
end

