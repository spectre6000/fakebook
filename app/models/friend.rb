class Friend < ActiveRecord::Base

  validates :friending_id, presence: true
  validates :friended_id, presence: true

end
