# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# SEED FILE NOTE:
  ## creates users that acually go into the database
User.create!(name: "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true,      
             activated: true, #makes this an already activated user, as if they have recieved link and clicked
             activated_at: Time.zone.now)#gives the current time in the current time zone
             
#FAKER GEM NOTE:
  ## faker gem (used below) creates bulk fake users(or other DB entries) for the seed file
  ## used to create fake names below

99.times do |n|
  name  = Faker::Name.name #FAKER GEM; a gem used to generate lots of fake DB entries
  email = "example-#{n+1}@railstutorial.org" # makes each fake email "example-number@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end

# makes a loops that goes through the first 6 users 
  ## goes through the users list 50 times making one post each
  ## this makes 50 posts for all 6 users aka 450 posts
    ## so user1 post, user2 post, user3 post user4 post etc
    ## then loops back to user1 49 more times
    
users = User.order(:created_at).take(6) #takes the first 6 users from the DB
50.times do #does the code below 50 times
  content = Faker::Lorem.sentence(5) #makes 5 sentences of lorem ipsum
  users.each { |user| user.microposts.create!(content: content)} #one post per user 
end

    