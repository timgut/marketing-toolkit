class Image < ApplicationRecord
  include Status

  belongs_to :creator, class_name: "User", foreign_key: :creator_id

  has_and_belongs_to_many :users

  has_many :image_users, class_name: "ImageUser"

  scope :recent,         ->(user) { where("images.creator_id = ? and images.created_at >= ?", user.id, DateTime.now - 2.weeks) }
  scope :shared_with_me, ->(user) { all.joins(:images_users).where("images_users.user_id = ? and images_users.user_id != ?", user.id, user.id) }

  class << self
    def find_by_url(url)
      Image.find_by(original_image_url: url)
    end
  end

  # Filenames have the two dashes (--) and 10 digit timestamp removed.
  def filename
    @friendly_filename ||= if original_image_url
      filename = original_image_url.split("/").last.split(".").first
      filename.sub(/--\d{10}/, "")
    else
      "Untitled Image"
    end
  end

  def upload_to_s3!(upload)
    # Persist the tempfile
    filepath = Rails.root.join("tmp").join("#{DateTime.now.to_i}-#{upload.original_filename}")
    File.open(filepath, 'wb') {|file| file << File.read(upload.tempfile.path)}

    # Upload to S3
    fullpath = s3_path(filename: upload.original_filename)
    service  = Aws::S3::Resource.new(region: "us-east-1", http_wire_trace: true)
    object   = service.bucket("toolkit.afscme.org").object(fullpath)
    object.upload_file(filepath, acl: "public-read")

    # Cleanup
    FileUtils.rm(filepath)
    self.update!(original_image_url: "https://s3.amazonaws.com/toolkit.afscme.org/#{fullpath}")
  end
end
