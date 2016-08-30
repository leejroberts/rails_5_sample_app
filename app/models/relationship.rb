class Relationship < ApplicationRecord
  # due to the fact that follower does not exist as a model
    #we do some fancy footwork below to tell rails where to look
    #i do not fully understand this yet...will fill in as i go...
  belongs_to :follower, class_name: 'User'
  belongs_to :followed, class_name: 'User'
  validates :follower_id, presence: 'true'
  validates :followed_id, presence: 'true'
end
