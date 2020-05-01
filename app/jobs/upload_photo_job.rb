class UploadPhotoJob < ApplicationJob
  queue_as :default

  def perform(filepath:, filename:, image:)
    Rails.logger.tagged("UploadPhotoJob", "#{image.id}") do
      ActiveRecord::Base.connection_pool.with_connection do
        fullpath = image.s3_path(filename: filename)
        service  = Aws::S3::Resource.new(region: "us-east-1")
        object   = service.bucket("toolkit.afscme.org").object(fullpath)
        response = object.upload_file(File.open(filepath), acl: "public-read")

        image.update!(original_image_url: "https://s3.amazonaws.com/toolkit.afscme.org#{fullpath}")
      end
    end
  end
end
