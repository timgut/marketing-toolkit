class Image < ApplicationRecord
  has_attached_file :image, storage: :s3, s3_credentials: Proc.new{|i| i.instance.__send__(:s3_credentials) }
  
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  validates_each :image_file_name do |record, attr, value|
    if User.current_user.images.map(&:image_file_name).include?(value)
      record.errors.add attr, "You already have an image named #{value}."
    end
  end

  has_and_belongs_to_many :users

  has_many :image_users, class_name: "ImageUser"

  scope :recent, ->{ all.joins(:images_users).where("user_id = ? and images.created_at >= ?", User.current_user.id, DateTime.now - 1.month) }
  scope :shared_with_me, ->{ all.joins(:images_users).where("user_id = ? and images_users.creator_id != ?", User.current_user.id, User.current_user.id) }

  def creator
    image_users.where(image_id: self.id).first.creator
  end
end
