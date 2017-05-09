class Image < ApplicationRecord
  include Status

  has_attached_file(
    :image,
    storage:        :s3,
    s3_credentials: Proc.new{|i| i.instance.__send__(:s3_credentials)},
    styles:         {cropped: ""},
    processors:     [:resize, :contextual_crop]
  )
  
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
  validates_uniqueness_of :image_file_name, scope: :creator_id

  belongs_to :creator, class_name: "User", foreign_key: :creator_id

  has_and_belongs_to_many :users

  has_many :image_users, class_name: "ImageUser"

  scope :recent, ->{ all.joins(:images_users).where("images_users.user_id = ? and images.created_at >= ?", User.current_user.id, DateTime.now - 1.month) }
  scope :shared_with_me, ->{ all.joins(:images_users).where("images_users.user_id = ? and images_users.user_id != ?", User.current_user.id, User.current_user.id) }

  serialize :crop_data, Hash

  attr_accessor :pos_x, :pos_y, :context, :resize, :crop_cmd, :resize_cmd, :drag_data

  def cropping?
    context.present? && pos_x.present? && pos_y.present?
  end

  def resizing?
    resize.present?
  end

  def reset_crop_data
    crop_data = {}
  end

  def set_crop_data!
    update_attributes(crop_data: {
      crop: self.crop_cmd,
      resize: self.resize_cmd,
      drag: {x: pos_x, y: pos_y}
    })
  end
end
