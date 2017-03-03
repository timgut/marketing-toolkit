class Image < ApplicationRecord
  has_attached_file :image, storage: :s3, s3_credentials: Proc.new{|i| i.instance.__send__(:s3_credentials) }
  
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
  validates_uniqueness_of :image_file_name

  has_and_belongs_to_many :users

  has_many :images_users, class_name: "ImageUser"

  scope :recent, ->{ all.joins(:images_users).where("user_id = ? and images.created_at >= ?", User.current_user.id, DateTime.now - 1.month) }
  scope :shared_with_me, ->{ all.joins(:images_users).where("user_id = ? and images_users.creator_id != ?", User.current_user.id, User.current_user.id) }

  # Unsure right now if this should be a method or association. This returns the User record for the creator.
  def creator
    images_users.where(user_id: User.current_user.id).first.creator
  end
end
