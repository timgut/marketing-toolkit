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

  scope :recent,         ->(user){ all.joins(:images_users).where("images_users.user_id = ? and images.created_at >= ?", user.id, DateTime.now - 1.month) }
  scope :shared_with_me, ->(user){ all.joins(:images_users).where("images_users.user_id = ? and images_users.user_id != ?", user.id, user.id) }

  serialize :crop_data, Hash

  attr_accessor :pos_x,     # When cropping, the X position of the image within the context image.
                :pos_y,     # When cropping, the Y position of the image within the context image.
                :context,   # The Template record to use for contextual cropping.
                :resize,    # Set to true to initiate the resize processor.
                :crop_cmd,  # The crop command sent to ImageMagick
                :resize_cmd # The resize command sent to ImagMagick


  class << self
    def find_by_url(url)
      file_name = url.split("/").last
      begin
        Image.find_by(image_file_name: file_name)
      rescue ActiveRecord::RecordNotFound
        false # Don't raise an error if the image isn't found
      end
    end
  end

  def cropping?
    context.present? && pos_x.present? && pos_y.present?
  end

  def orientation
    image.width > image.height ? :landscape : :portrait
  end

  def resizing?
    resize.present?
  end

  def reset_crop_data
    crop_data = {}
  end

  def set_crop_data!
    update_attributes(crop_data: {
      crop:   self.crop_cmd,
      resize: self.resize_cmd,
      drag:   {x: pos_x, y: pos_y}
    })
  end
end
