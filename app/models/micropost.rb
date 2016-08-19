class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) } #stabby somthing(can't remember)...he discusses it, but just look up stabby ruby  
       # notice -> vs =>
  mount_uploader :picture, PictureUploader #this is part of the carrier wave implementation, notice folder uploaders in the file tree
  validates :user_id, presence: true 
  validates :content, presence: true, length: { maximum: 140 }
  validate :picture_size #NOTE: validate is singular, b/c :picture_size is a method, not a attribute (this is likely a rails convention)

private
  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "Should be less than 5mb")
    end
  end


end
=begin NOTE CarrierWave important!
  carrierwave is using an application called imagemagick for image resizing. the application IS NOT A GEM
  you need to install it in your development environment. see hartl 13.4.3 image resizing
=end
