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

  # Filenames have the two dashes (--) and 10 digit timestamp removed.
  def filename
    @friendly_filename ||= if original_image_url
      filename = original_image_url.split("/").last.split(".").first
      filename.sub(/--\d{10}/, "")
    else
      "TODO"
    end
  end

  def upload_to_s3!(file)
    fullpath = s3_path(filename: file.original_filename)
    service  = Aws::S3::Resource.new(region: "us-east-1")
    object   = service.bucket("toolkit.afscme.org").object(fullpath)
    response = object.upload_file(file.tempfile, acl: "public-read")

    self.update!(original_image_url: "https://s3.amazonaws.com/toolkit.afscme.org#{fullpath}")
  end
end
