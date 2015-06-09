class Friend < ActiveRecord::Base

  validates :friend_id, presence: true
  validates :friended_id, presence: true

end
