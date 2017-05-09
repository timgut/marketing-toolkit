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

  scope :recent, ->{ all.joins(:images_users).where("user_id = ? and images.created_at >= ?", User.current_user.id, DateTime.now - 1.month) }
  scope :shared_with_me, ->{ all.joins(:images_users).where("user_id = ? and images_users.user_id != ?", User.current_user.id, User.current_user.id) }

  attr_accessor :pos_x, :pos_y, :context, :resize

  def cropping?
    context.present? && pos_x.present? && pos_y.present?
  end

  def resizing?
    resize.present?
  end
end
