class Image < ApplicationRecord
  include Status

  PROCESSORS = [

  ]

  has_attached_file(
    :image,
    storage:        :s3,
    s3_protocol:    "https",
    s3_credentials: Proc.new{|i| i.instance.__send__(:s3_credentials)},
    styles:         {cropped: ""},
    processors:     [
      :papercrop_normalize, # 
      :papercrop,           # 
      :papercrop_resize,    # 
      :contextual_resize,   # 
      :contextual_crop      # 
    ]
  )

  crop_attached_file :image
  
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
  validates_uniqueness_of :image_file_name, scope: :creator_id

  belongs_to :creator, class_name: "User", foreign_key: :creator_id

  has_and_belongs_to_many :users

  has_many :image_users, class_name: "ImageUser"

  scope :recent,         ->(user) { where("images.creator_id = ? and images.created_at >= ?", user.id, DateTime.now - 2.weeks) }
  scope :shared_with_me, ->(user) { all.joins(:images_users).where("images_users.user_id = ? and images_users.user_id != ?", user.id, user.id) }

  serialize :crop_data, Hash

  attr_accessor :pos_x,         # contextual_crop setting: the X position of the image within the context image.
                :pos_y,         # contextual_crop setting: the Y position of the image within the context image.
                :context,       # The Template record to use for contextual cropping.
                :commands,      # An array of commands sent to ImagMagick
                :resize_height, # The target height to for images cropped with Papercrop
                :resize_width,  # The target width to for images cropped with Papercrop
                :strategy,      # Set to :papercrop or :contextual_crop to enable the processors
                :paperclip_resize

  class << self
    def find_by_url(url)
      file_name = url.split("/").last
      begin
        Image.find_by!(image_file_name: file_name)
      rescue ActiveRecord::RecordNotFound
        false # Don't raise an error if the image isn't found
      end
    end
  end

  def orientation
    image.width > image.height ? :landscape : :portrait
  end

  def reset_crop_data
    self.crop_data = {}
  end

  def reset_commands
    self.commands = []
  end

  def set_crop_data!
    update_attributes(crop_data: {
      commands: self.commands,
      drag:     {x: self.pos_x, y: self.pos_y}
    })
  end
end
