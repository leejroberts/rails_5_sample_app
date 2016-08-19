if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      # configuration for amazon s3
      :provider              => 'AWS',#AWS == amazon web services
      :aws_access_key_id     => ENV['S3_ACCESS_KEY'],#this variable is set in a heroku command
      :aws_secret_access_key => ENV['S3_SECRET_ACCESS_KEY']#as is this one
    }
    config.fog_directory     = ENV['S3_BUCKET']#likely this one too.
  end
end
#the function of this is to use AWS for image storage in the production environment with Heroku

# the following are entered into the terminal for set-up purposes
  # the AWS user we set up is named lee...the access codes are somewhere safe

# heroku config:set S3_ACCESS_KEY=<access key>
# $ heroku config:set S3_SECRET_KEY=<secret key>
# $ heroku config:set S3_BUCKET=<bucket name>