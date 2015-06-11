class Post < ActiveRecord::Base

  belongs_to :user
  # has_many :likes
  default_scope -> { order(created_at: :desc) }
  mount_uploader :image, ImageUploader
  validates :user_id, presence: true
  validates :content, presence: true

end
