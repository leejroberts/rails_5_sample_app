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