class Image < ApplicationRecord
  include Status

  belongs_to :creator, class_name: "User", foreign_key: :creator_id

  has_and_belongs_to_many :users

  has_many :image_users, class_name: "ImageUser"

  scope :recent,         ->(user) { where("images.creator_id = ? and images.created_at >= ?", user.id, DateTime.now - 2.weeks) }
  scope :shared_with_me, ->(user) { all.joins(:images_users).where("images_users.user_id = ? and images_users.user_id != ?", user.id, user.id) }

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

  def upload_to_s3(file:)
    s3 = Aws::S3::Resource.new(region: "us-east-1")
    obj = s3.bucket("toolkit.afscme.org").object(image_file_name)
    obj.upload_file(file)
  end

  # Legacy Paperclip Images
  def image
    OpenStruct.new(url: ->(style){self.__send__("#{style}_image_url")})
  end
end
